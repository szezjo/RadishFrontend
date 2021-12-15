import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    getUserData();
    retrieve();
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
    if (spotifyCredentials.clientId == null ||
        spotifyCredentials.clientSecret == null ||
        spotifyCredentials.accessToken == null ||
        spotifyCredentials.refreshToken == null ||
        spotifyCredentials.scopes == null ||
        spotifyCredentials.expiration == null) {
      return;
    }

    print("ID " + spotifyCredentials.clientId.toString());
    print("ACCESS " + spotifyCredentials.accessToken.toString());
    print("SCOPES " + spotifyCredentials.scopes!.join(", "));

    _spotifyClient = sp.SpotifyApi(spotifyCredentials);
    _spotifyClient.getCredentials().then((value) {
      saveCredentials(value);
    });
  }

  List<String> _searchResults = [];
  List<String> _searchHrefs = [];

  Future<void> _search(sp.SpotifyApi spotify, String query) async {
    _searchResults = [];
    _searchHrefs = [];
    var search = await spotify.search.get(query).first(5).catchError((err) {
      print((err as sp.SpotifyException).message);
      showAuthErrToast();
    });
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

  void showAuthErrToast() => Fluttertoast.showToast(
      msg: 'Link your Spotify account in settings to use this function',
      fontSize: 18);

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    title = data["title"];
    songs = data["songs"];

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
                    child: user?.profile?.avatar != null
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
                                ]));
                      });
                },
                onDoubleTap: () => print("liked ${songs.elementAt(index)}"),
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
                          onPressed: () =>
                              print("faved ${songs.elementAt(index)}"),
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
