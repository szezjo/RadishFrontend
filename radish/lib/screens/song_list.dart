import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/custom_widgets/station_slider.dart';

import 'package:spotify/spotify.dart' as sp;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({Key? key}) : super(key: key);

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  late String title;
  late List<String> songs;

  List<Log>? activityLog;
  User? user;

  getUserData() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var userData = storage.getString('userData');
    Map json = jsonDecode(userData.toString());
    Map<String, dynamic> stringQueryParameters =
        json.map((key, value) => MapEntry(key.toString(), value));

    setState(() {
      user = User.fromJson(stringQueryParameters);
    });
  }

  saveToUserData(user) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user);
    storage.setString('userData', userJson);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  showStation(Station? station) async {
    if (station != null) {
      Navigator.pushNamed(context, "/station", arguments: {
        "station": station,
      });
    }
  }

  isSongLiked(String name) {
    return user!.songs!.discovered!.contains(name);
  }

  /* ####################################################################
  #                              SPOTIFY STUFF                          #
  #################################################################### */

  var _spotifyClient;

  final _scopes = {
    'user-read-playback-state',
    'user-follow-read',
    'playlist-modify-private',
    'playlist-modify-public'
  };

  void authorize() async {
    var client_id = "490d4f51b3134954a90ad7ad14f6bb56";
    var secret_id = "45c9d4b6362a44f0820dec6fb14fd796";

    var credentials = sp.SpotifyApiCredentials(client_id, secret_id);
    _spotifyClient = await _getUserAuthenticatedSpotifyApi(credentials);

    _spotifyClient.getCredentials().then((value) {
      saveCredentials(value);
      _createPlaylist(_spotifyClient);
    });
  }

  void saveCredentials(sp.SpotifyApiCredentials credentials) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString('sp.clientId', credentials.clientId.toString());
    storage.setString('sp.clientSecret', credentials.clientSecret.toString());
    storage.setString('sp.accessToken', credentials.accessToken.toString());
    storage.setString('sp.refreshToken', credentials.refreshToken.toString());
    storage.setString('sp.scopes', credentials.scopes!.join("#;#;#"));
    storage.setString(
        'sp.expiration', credentials.expiration!.toIso8601String());
  }

  Future<sp.SpotifyApiCredentials> loadCredentials() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String clientId = storage.getString('sp.clientId').toString();
    String clientSecret = storage.getString('sp.clientSecret').toString();
    String accessToken = storage.getString('sp.accessToken').toString();
    String refreshToken = storage.getString('sp.refreshToken').toString();
    List<String> scopes = storage.getString('sp.scopes')!.split("#;#;#");
    DateTime expiration =
        DateTime.parse(storage.getString('sp.expiration').toString());

    final spotifyCredentials = sp.SpotifyApiCredentials(clientId, clientSecret,
        accessToken: accessToken,
        refreshToken: refreshToken,
        scopes: scopes,
        expiration: expiration);

    return spotifyCredentials;
  }

  void retrieve() async {
    final spotifyCredentials = await loadCredentials();

    print("ID " + spotifyCredentials.clientId.toString());
    print("ACCESS " + spotifyCredentials.accessToken.toString());
    print("SCOPES " + spotifyCredentials.scopes!.join(", "));

    _spotifyClient = sp.SpotifyApi(spotifyCredentials);
    _spotifyClient.getCredentials().then((value) {
      saveCredentials(value);
    });
  }

  Future<sp.SpotifyApi?> _getUserAuthenticatedSpotifyApi(
      sp.SpotifyApiCredentials credentials) async {
    var redirect = "radish:/";
    print(redirect);
    var grant = sp.SpotifyApi.authorizationCodeGrant(credentials);
    var authUri =
        grant.getAuthorizationUrl(Uri.parse(redirect), scopes: _scopes);

    var redirectUrl;
    final result = await FlutterWebAuth.authenticate(
        url: authUri.toString(), callbackUrlScheme: 'radish');

    if (result == '' || (redirectUrl = Uri.tryParse(result)) == null) {
      print('Invalid redirect url');
      return null;
    }

    var client =
        await grant.handleAuthorizationResponse(redirectUrl.queryParameters);
    return sp.SpotifyApi.fromClient(client);
  }

  String getAccessToken(String toParse) {
    if (toParse.contains("access_token")) {
      int start = toParse.indexOf("access_token=") + "access_token=".length;
      String newSub = toParse.substring(start);
      int end = newSub.indexOf('&');
      return newSub.substring(0, end);
    } else {
      return '';
    }
  }

  void authenticate() async {
    final result = await FlutterWebAuth.authenticate(
        url:
            "https://accounts.spotify.com/authorize?client_id=490d4f51b3134954a90ad7ad14f6bb56&redirect_uri=radish:/&scope=user-read-currently-playing&response_type=token&state=SomeStateHere",
        callbackUrlScheme: 'radish');

    final response = Uri.parse(result);
    print(getAccessToken(response.toString()));
  }

  List<String> _searchResults = [];
  List<String> _searchHrefs = [];

  Future<void> _search(sp.SpotifyApi spotify, String query) async {
    _searchResults = [];
    _searchHrefs = [];
    var search = await spotify.search
        .get(query)
        .first(5)
        .catchError((err) => print((err as sp.SpotifyException).message));
    if (search == null) return;
    search.forEach((pages) {
      pages.items!.forEach((item) {
        if (item is sp.TrackSimple) {
          _searchResults
              .add('${item.artists!.elementAt(0).name} - ${item.name}');
          _searchHrefs.add('${item.uri}');
        }
      });
    });
  }

  Future<void> _createPlaylist(sp.SpotifyApi spotify) async {
    var got = await spotify.me.get();
    if (got == null) return;
    var id = got.id.toString();

    var playlists = spotify.playlists;
    var playlist = await playlists.createPlaylist(id, 'Discovered on Radish',
        public: true,
        collaborative: false,
        description: 'Your new songs discovered on Radish');
    var playlistId = playlist.id;
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString('playlistId', playlistId.toString());
  }

  Future<void> _addToPlaylist(sp.SpotifyApi spotify, String songUri) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var playlistId = storage.getString('playlistId');
    if (playlistId == null) {
      await _createPlaylist(spotify);
      playlistId = storage.getString('playlistId');
    }
    var playlists = spotify.playlists;
    playlists.addTrack(songUri, playlistId.toString());
  }

  void showToast() =>
      Fluttertoast.showToast(msg: 'Added to playlist', fontSize: 18);

  handleLike(String song) async {
    if (user == null) {
      print("no user set");
      return;
    }

    String endpointUrl = "add_to_discovered";

    final response = await http.post(
        Uri.parse('https://radish-scening.herokuapp.com/user/$endpointUrl'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'token': user?.token, 'song': song}));

    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T GET $endpointUrl");
      print("${jsonDecode(response.body)}");
      return;
    }

    print("${response.statusCode} GOT $endpointUrl");
    setState(() {
      user?.songs?.discovered?.add(song);
    });
    await saveToUserData(user);
  }

  handleUnlike(String song) async {
    if (user == null) {
      print("no user set");
      return;
    }

    String endpointUrl = "remove_song_from_discovered";

    final response = await http.post(
        Uri.parse('https://radish-scening.herokuapp.com/user/$endpointUrl'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'token': user?.token, 'song': song}));

    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T GET $endpointUrl");
      print("${jsonDecode(response.body)}");
      return;
    }

    print("${response.statusCode} GOT $endpointUrl");
    setState(() {
      user?.songs?.discovered?.remove(song);
    });
    await saveToUserData(user);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    title = data["title"];
    if (data["songs"] == null) {
      songs = [];
    } else {
      songs = data["songs"];
    }

    return Scaffold(
      body: Column(children: [
        const SizedBox(height: 60.0),
        Container(
          height: 80.0,
          color: ThemeConfig.darkBGSecondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    child: user?.profile?.avatar != null &&
                        user?.profile?.avatar != ""
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/avatarPlaceholder.png',
                            image: user!.profile!.avatar!,
                            height: 50.0,
                            width: 50.0,
                            fit: BoxFit.contain)
                        : Image.asset('images/avatarPlaceholder.png',
                            height: 50.0, width: 50.0, fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: List.generate(songs.length, (int index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            color: Colors.black12,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                      title: Text('Search on Spotify'),
                                      onTap: () async {
                                        await _search(_spotifyClient,
                                            songs.elementAt(index));
                                        if (_searchResults.length > 0) {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    color: Colors.black12,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: List.generate(
                                                            _searchResults
                                                                .length,
                                                            (int index) {
                                                          return ListTile(
                                                              title: Text(
                                                                  _searchResults
                                                                      .elementAt(
                                                                          index)),
                                                              onTap: () {
                                                                _addToPlaylist(
                                                                    _spotifyClient,
                                                                    _searchHrefs
                                                                        .elementAt(
                                                                            index));
                                                                showToast();
                                                              });
                                                        })));
                                              });
                                        } else {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    color: Colors.black12,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          ListTile(
                                                            title: Text(
                                                                'No search results'),
                                                          )
                                                        ]));
                                              });
                                        }
                                      }),
                                  ListTile(
                                      title: Text('Authorize (temp)'),
                                      onTap: () => authorize()),
                                  ListTile(
                                      title: Text('Retrieve (temp)'),
                                      onTap: () => retrieve()),
                                  ListTile(
                                      title: Text('Reset playlist'),
                                      onTap: () =>
                                          _createPlaylist(_spotifyClient)),
                                ]));
                      });
                },
                onDoubleTap: () {
                            if (isSongLiked(songs.elementAt(index))) {
                              handleUnlike(songs.elementAt(index));
                            } else {
                              handleLike(songs.elementAt(index));
                            }
                          },
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: ThemeConfig.darkDivider,
                    ),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.music_note_rounded,
                              color: ThemeConfig.darkAccentPrimary,
                              size: 28.0,
                            )),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          songs.elementAt(index),
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ThemeConfig.darkIcons,
                              fontSize: 18.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            if (isSongLiked(songs.elementAt(index))) {
                              handleUnlike(songs.elementAt(index));
                            } else {
                              handleLike(songs.elementAt(index));
                            }
                          },
                          icon: isSongLiked(songs.elementAt(index))
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: ThemeConfig.darkAccentPrimary,
                                  size: 24.0,
                                )
                              : Icon(
                                  Icons.favorite_outline_rounded,
                                  color: ThemeConfig.darkIcons,
                                  size: 24.0,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ]),
    );
  }
}
