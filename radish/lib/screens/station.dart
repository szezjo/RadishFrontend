import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:palette_generator/palette_generator.dart';

class StationPage extends StatefulWidget {

  const StationPage({Key? key}) : super(key: key);

  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {

  late Station station;
  bool mode = true;

  User? user;

  play() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String station = jsonEncode(this.station);
    storage.setString('currentlyPlaying', station);

    Navigator.pushNamed(context, "/player");
  }

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

  Future<Color> getImagePalette () async {
    if (station.cover == null) {
      return Colors.white;
    }
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(NetworkImage(station.cover!),);
    return paletteGenerator.dominantColor?.color ?? Colors.white;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    station = data["station"];

    return Scaffold(
        body: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 60.0),
                      FutureBuilder<Color>(
                          future: getImagePalette(),
                          builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 80.0,
                                color: snapshot.data,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 110.0, bottom: 8.0),
                                    child: Text(
                                        station.name ?? "",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: snapshot.data!.computeLuminance() > 0.1 ? ThemeConfig.darkBGSecondary : Colors.white,
                                            fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                ),
                              );
                            }
                            else {
                              return Container(
                                height: 80.0,
                                color: ThemeConfig.darkBGSecondary,
                                child: Center(
                                  child: Text(
                                      station.name ?? "",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: ThemeConfig.darkBGSecondary,
                                          fontWeight: FontWeight.bold)
                                  ),
                                ),
                              );
                            }
                          }),
                      Container(
                        height: 60.0,
                        color: ThemeConfig.darkBGSecondary,
                      )
                    ],
                  ),
                  Positioned(
                      top: 150.0,
                      left: 110.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              station.status?.currently_playing_song ?? "",
                          style: TextStyle(fontSize: 12.0)),
                          Text(
                            station.status?.currently_playing_song ?? "",
                            style: TextStyle(
                              fontSize: 11.0,
                              color: ThemeConfig.darkIcons,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                  ),
                  Positioned(
                    top: 95.0,
                    left: 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.white,
                        child: FadeInImage.assetNetwork(
                        placeholder: 'images/stationPlaceholder.png',
                        image: station.cover ?? "invalid",
                        height: 90.0,
                        width: 90.0,
                        fit: BoxFit.contain
                        ),
                      ),
                    ),
                  )
                ]
              ),
              Container(
                height: 90.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                  "Quality",
                                  style: TextStyle(fontSize: 18.0)),
                              Text("${station.streams?.codec ?? ""}, ${station.streams?.bitrate ?? ""}",
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: ThemeConfig.darkIcons,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: play,
                          icon: Icon(
                            Icons.play_circle_fill,
                            color: ThemeConfig.darkIcons,
                            size: 28.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                decoration: BoxDecoration(
                  color: ThemeConfig.darkBGSecondary,
                  border: Border.symmetric(horizontal: BorderSide(
                    color: ThemeConfig.darkDivider,
                  ),)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                      decoration: mode ? BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: ThemeConfig.darkAccentPrimary,
                          ),
                        )
                      ) : null,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                              mode = true;
                            }
                          );
                        },
                        icon: Icon(
                          mode ? Icons.info_outline_rounded : Icons.info_rounded,
                          color: mode ? ThemeConfig.darkAccentPrimary : ThemeConfig.darkIcons,
                          size: 28.0,
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: !mode ? BoxDecoration(
                          border: Border(bottom: BorderSide(
                              color: ThemeConfig.darkAccentPrimary,
                            ),
                          )
                      ) : null,
                      child: IconButton(
                        onPressed: () {
                            setState(() {
                              mode = false;
                              }
                            );
                          },
                          icon: Icon(
                          Icons.history_rounded,
                          color: !mode ? ThemeConfig.darkAccentPrimary : ThemeConfig.darkIcons,
                          size: 28.0,
                        )
                      ),
                    ),
                  )
                  ],
              ),
              Expanded(
                  child: mode ? stationInfo(station)
                        : stationHistory(station)
              )
            ]
        ),
    );
  }
}

Widget stationInfo(Station station) {

  return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        infoItem("Genre", station.tags),
        infoItem("Language", station.language),
        infoItem("Country", station.country),
        GestureDetector(
          onTap: () => print(station.streams?.url ?? ""),
          child: infoItem("Homepage", station.streams?.url)
        ),
      ]
  );
}

Widget infoItem(String title, String? subtitle) {

  TextStyle SubtitleTextStyle = TextStyle(
    fontSize: 11.0,
    color: ThemeConfig.darkIcons,
  );

  return Container(
    height: 90.0,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: ThemeConfig.darkDivider,
          ),)
        ),
    child: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, color: Colors.white)
            ),
            Text(
              subtitle ?? "",
              style: SubtitleTextStyle
          ),
        ],
      ),
    ),
  );
}

Widget stationHistory(Station station) {
    return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: List.generate(station.history?.length ?? 0, (int index) {
        return GestureDetector(
          onDoubleTap: () => print("liked ${station.history?.elementAt(index)}"),
          child: Container(
            height: 60.0,
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeConfig.darkDivider,
                  ),)
            ),
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
                    )
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    station.history?.elementAt(index) ?? "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: ThemeConfig.darkIcons,
                        fontSize: 18.0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => print("faved ${station.history?.elementAt(index)}"),
                    icon: Icon(
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
    );
}

