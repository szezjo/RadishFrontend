import 'package:flutter/material.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';

import 'package:spotify/spotify.dart' as sp;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 60.0),
        Container(
          height: 80.0,
          color: ThemeConfig.darkBGSecondary,
          child: Center(
            child: Text("Settings",
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
                title: Text('Authorize Spotify'),
                subtitle: Text('Link to your Spotify account'),
                onTap: () => authorize()),
            ListTile(
                title: Text('About'),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          color: Colors.black12,
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Text(
                                  'Radish is a radio player software. All rights to compatible radio stations belong to their original owners.\n\nCreated by:\nAda Cieńciała\nMateusz Groblewski\nWiktor Rojecki\n\nCopyright 2021')));
                    })),
            ListTile(
                title: Text('Version'),
                subtitle: Text('0.12.15beta')),
            ListTile(
                title: Text('Third-party software'),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          color: Colors.black12,
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Text(
                                  'Spotify API: https://github.com/rinukkusu/spotify-dart\nFlutter Web Auth: https://github.com/LinusU/flutter_web_auth\nFlutter Radio Player: https://github.com/Sithira/FlutterRadioPlayer\nRadio-Browser API: https://api.radio-browser.info')));
                    })),
          ],
        ))
      ],
    ));
  }
}
