import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:radish/models/station.dart';

class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({Key? key}) : super(key: key);
  final playerState = FlutterRadioPlayer.flutter_radio_paused;

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  FlutterRadioPlayer _radioPlayer = FlutterRadioPlayer();
  Station? station;

  @override
  void initState() {
    super.initState();
    if (widget.playerState == false ) initRadioService();
    else {
      getStationData();
    }
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
    _radioPlayer.setUrl(station!.streams!.url!, "true");
    return station!.streams!.url!;
  }

  Future<void> initRadioService() async {
    String url = await getStationData();
    await Future.delayed(const Duration(seconds: 2));
    print(url);
    print(station!.streams!.url!);
    url = station!.streams!.url!;
    print(station!.name!);
    // String url = "http://ais.absoluteradio.co.uk/absoluteclassicrock.mp3?";
    try {
      await _radioPlayer.init(
        "Flutter Radio Player",
        "Live",
          url,
        "true"
      );
      print("Done");
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  @override
  Widget build(BuildContext context) {

    String getTitle(String metadata) {
      if(metadata.contains('ICY: ') && metadata.contains('title=')) {
        int start = metadata.indexOf('title=');
        start+=7;
        String sub = metadata.substring(start);
        int end = sub.indexOf('"');
        return sub.substring(0, end);
      }
      else {
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
                    Text(
                      'Currently playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14)
                    ),
                    Text(
                      station!.name ?? "",
                      // "Absolute Radio",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 2, 
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(60, 0, 60, 0),
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
                          builder: (context, snapshot) {
                            var title = getTitle(snapshot.data.toString());
                            print(title);
                            if(title=='') {
                              return const Text('Playing', style: TextStyle(color: Colors.grey, fontSize: 18));
                            }
                            else {
                              return Text(title, style: const TextStyle(fontSize: 18));
                            }
                            
                          },
                        ),
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
                      initialData: widget.playerState,
                      builder: (context, snapshot) {
                        if (snapshot.data == FlutterRadioPlayer.flutter_radio_playing) {
                          return IconButton(
                            onPressed: () async {
                              await _radioPlayer.stop();
                            },
                            icon: const Icon(
                              Icons.stop_rounded,
                              color: Colors.grey,
                              size: 36,
                            ),
                          );
                        }
                        else {
                          return IconButton(
                            onPressed: () async {
                              await initRadioService();
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
                )
              )
            ],
          )
        )
      )
    );
  }
}