import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:radish/models/station.dart';

class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({Key? key}) : super(key: key);

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  FlutterRadioPlayer _radioPlayer = FlutterRadioPlayer();
  var _playerState = FlutterRadioPlayer.flutter_radio_stopped;
  Station? station;

  @override
  void initState() {
    super.initState();
    initRadioService();
  }

  String getPlayerState() {
    return _playerState;
  }

  Future<String> getStationData() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var userData = storage.getString('currentlyPlaying');
    Map json = jsonDecode(userData.toString());
    Map<String, dynamic> stringQueryParameters =
        json.map((key, value) => MapEntry(key.toString(), value));

    setState(() {
      station = Station.fromJson(stringQueryParameters);
    });
    print("URL: " + station!.streams!.url.toString());
    return station!.streams!.url!;
  }

  Future<String> getCurrentUrl() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString('currentUrl').toString();
  }

  Future<void> setCurrentUrl(String url) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString('currentUrl', url);
  }

  Future<String> setUrlFromData() async {
    String url = await getStationData();
    String oldUrl = await getCurrentUrl();
    print("New URL: " + url);
    print("Old URL: " + oldUrl);
    if (url != oldUrl) {
      _radioPlayer.setUrl(url, "true");
      await setCurrentUrl(url);
    } else {
      _playerState = FlutterRadioPlayer.flutter_radio_playing;
    }
    return url;
  }

  Future<void> initRadioService() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    bool? isInit = storage.getBool('radioInit');
    if (isInit != null && isInit) {
      setUrlFromData();
    } else {
      String url = await getStationData();
      await Future.delayed(const Duration(seconds: 2));
      print(url);
      // print(station!.streams!.url!);
      // url = station!.streams!.url!;
      // print(station!.name!);
      // String url = "http://ais.absoluteradio.co.uk/absoluteclassicrock.mp3?";
      try {
        await _radioPlayer.init("Radish", "Live", url, "true");
        SharedPreferences storage = await SharedPreferences.getInstance();
        storage.setBool('radioInit', true);
        await setCurrentUrl(url);
        print("Done");
      } on PlatformException {
        print("Exception occurred while trying to register the services.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String getTitle(String metadata) {
      if (metadata.contains('ICY: ') && metadata.contains('title=')) {
        int start = metadata.indexOf('title=');
        start += 7;
        String sub = metadata.substring(start);
        int end = sub.indexOf('"');
        return sub.substring(0, end);
      } else {
        return '';
      }
    }

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Currently playing',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text(station!.name ?? "",
                                // "Absolute Radio",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                60, 0, 60, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                station!.cover!,
                                // 'https://i.scdn.co/image/ab67616d00001e029b95ca5babfa8f869f87e026',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              StreamBuilder(
                                initialData: "",
                                stream: _radioPlayer.metaDataStream,
                                builder: (metadataContext, metadataSnapshot) {
                                  var title = getTitle(
                                      metadataSnapshot.data.toString());
                                  print('title' + title);
                                  return Text(title,
                                      style: const TextStyle(fontSize: 18));
                                },
                              ),
                              StreamBuilder(
                                  initialData: getPlayerState(),
                                  stream: _radioPlayer.isPlayingStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.data ==
                                        FlutterRadioPlayer
                                            .flutter_radio_playing) {
                                      return const Text('Playing',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18));
                                    } else if (snapshot.data ==
                                        FlutterRadioPlayer
                                            .flutter_radio_stopped) {
                                      return const Text('Stopped',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18));
                                    } else if (snapshot.data ==
                                        FlutterRadioPlayer
                                            .flutter_radio_loading) {
                                      return const Text('Buffering',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18));
                                    } else if (snapshot.data ==
                                        FlutterRadioPlayer
                                            .flutter_radio_error) {
                                      return const Text('Error',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18));
                                    } else {
                                      return const Text('',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18));
                                    }
                                  }),
                              // Text(
                              //   'Innocent',
                              //   style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)
                              // ),
                              // Text(
                              //   'Mike Oldfield',
                              //   style: TextStyle(color: Colors.grey, fontSize: 18)
                              // )
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: _radioPlayer.isPlayingStream,
                              initialData: getPlayerState(),
                              builder: (context, snapshot) {
                                if (snapshot.data ==
                                    FlutterRadioPlayer.flutter_radio_playing) {
                                  return IconButton(
                                    onPressed: () async {
                                      await _radioPlayer.stop();
                                      SharedPreferences storage =
                                          await SharedPreferences.getInstance();
                                      storage.setBool('radioInit', false);
                                    },
                                    icon: const Icon(
                                      Icons.stop_rounded,
                                      color: Colors.grey,
                                      size: 36,
                                    ),
                                  );
                                } else {
                                  return IconButton(
                                    onPressed: () async {
                                      await initRadioService();
                                      SharedPreferences storage =
                                          await SharedPreferences.getInstance();
                                      storage.setBool('radioInit', true);
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.grey,
                                      size: 36,
                                    ),
                                  );
                                }
                              },
                            ),
                            const Icon(
                              Icons.favorite_border,
                              color: Colors.white10,
                              size: 60,
                            ),
                            const Icon(
                              Icons.keyboard_control,
                              color: Colors.grey,
                              size: 36,
                            )
                          ],
                        ))
                  ],
                ))));
  }
}
