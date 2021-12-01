import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:io';
import 'dart:convert';

class SpotifyAuthPage extends StatefulWidget {
  const SpotifyAuthPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SpotifyAuthPage> createState() => _SpotifyAuthPageState();
}

class _SpotifyAuthPageState extends State<SpotifyAuthPage> {
  String _token = '';

  void _changeToken(newToken) {
    setState(() {
      _token = newToken;
    });
  }

  final _scopes = {
    'user-read-playback-state',
    'user-follow-read',
    'playlist-modify-private'
  };

  void authorize() async {
    var client_id = "490d4f51b3134954a90ad7ad14f6bb56";
    var secret_id = "45c9d4b6362a44f0820dec6fb14fd796";

    var credentials = SpotifyApiCredentials(client_id, secret_id);
    var spotify = await _getUserAuthenticatedSpotifyApi(credentials);
    if (spotify == null) {
      exit(0);
    }
    await _currentlyPlaying(spotify);
    await _devices(spotify);
    await _followingArtists(spotify);
    await _search(spotify);
  }

  Future<SpotifyApi?> _getUserAuthenticatedSpotifyApi(
    SpotifyApiCredentials credentials
  ) async {
    var redirect = "radish:/";
    print(redirect);
    var grant = SpotifyApi.authorizationCodeGrant(credentials);
    var authUri = grant.getAuthorizationUrl(Uri.parse(redirect), scopes: _scopes);

    var redirectUrl;
    final result = await FlutterWebAuth.authenticate(
      url: authUri.toString(),
      callbackUrlScheme: 'radish'
    );

    if (result == '' || (redirectUrl = Uri.tryParse(result)) == null) {
      print('Invalid redirect url');
      return null;
    }

    var client = await grant.handleAuthorizationResponse(redirectUrl.queryParameters);
    return SpotifyApi.fromClient(client);
  }

  Future<void> _currentlyPlaying(SpotifyApi spotify) async =>
    await spotify.me.currentlyPlaying().then((Player? a) {
      if (a == null) {
        print('Nothing currently playing.');
        return;
      }
      print('Currently playing: ${a.item?.name}');
    }).catchError(_prettyPrintError);

  Future<void> _search(SpotifyApi spotify) async {
    var search = await spotify.search
        .get('愛し子よ')
        .first(2)
        .catchError((err) => print((err as SpotifyException).message));
    if (search == null) {
      return;
    }
    search.forEach((pages) {
      pages.items!.forEach((item) {
        if (item is PlaylistSimple) {
          print('Playlist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}:\n'
              'collaborative: ${item.collaborative}\n'
              'href: ${item.href}\n'
              'trackslink: ${item.tracksLink!.href}\n'
              'owner: ${item.owner}\n'
              'public: ${item.owner}\n'
              'snapshotId: ${item.snapshotId}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'images: ${item.images!.length}\n'
              '-------------------------------');
        }
        if (item is Artist) {
          print('Artist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              '-------------------------------');
        }
        if (item is TrackSimple) {
          print('Track:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'isPlayable: ${item.isPlayable}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'discNumber: ${item.discNumber}\n'
              'trackNumber: ${item.trackNumber}\n'
              'explicit: ${item.explicit}\n'
              '-------------------------------');
        }
        if (item is AlbumSimple) {
          print('Album:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'albumType: ${item.albumType}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'images: ${item.images!.length}\n'
              'releaseDate: ${item.releaseDate}\n'
              'releaseDatePrecision: ${item.releaseDatePrecision}\n'
              '-------------------------------');
        }
      });
    });
  }

  Future<void> _devices(SpotifyApi spotify) async =>
    await spotify.me.devices().then((Iterable<Device>? devices) {
      if (devices == null) {
        print('No devices currently playing.');
        return;
      }
      print('Listing ${devices.length} available devices:');
      print(devices.map((device) => device.name).join(', '));
    }).catchError(_prettyPrintError);

  Future<void> _followingArtists(SpotifyApi spotify) async {
    var cursorPage = spotify.me.following(FollowingType.artist);
    await cursorPage.first().then((cursorPage) {
      print(cursorPage.items!.map((artist) => artist.name).join(', '));
    }).catchError((ex) => _prettyPrintError(ex));
  }

  void _prettyPrintError(Object error) {
    if (error is SpotifyException) {
      print('${error.status} : ${error.message}');
    } else {
      print(error);
    }
  }

  String getAccessToken(String toParse) {
    if(toParse.contains("access_token")) {
      int start = toParse.indexOf("access_token=")+"access_token=".length;
      String newSub = toParse.substring(start);
      int end = newSub.indexOf('&');
      return newSub.substring(0,end);
    }
    else {
      return '';
    }
  }

  void authenticate() async {
    final result = await FlutterWebAuth.authenticate(
      url: "https://accounts.spotify.com/authorize?client_id=490d4f51b3134954a90ad7ad14f6bb56&redirect_uri=radish:/&scope=user-read-currently-playing&response_type=token&state=SomeStateHere",
      callbackUrlScheme: 'radish'
    );

    final response = Uri.parse(result);
    print(getAccessToken(response.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your token:',
            ),
            Text(
              _token,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: authorize,
        tooltip: 'Authorize',
        child: const Icon(Icons.add),
      ),
    );
  }
}