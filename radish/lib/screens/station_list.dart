import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';

class StationListPage extends StatefulWidget {

  const StationListPage({Key? key}) : super(key: key);

  @override
  State<StationListPage> createState() => _StationListPageState();
}

class _StationListPageState extends State<StationListPage> {

  late String category;
  late List<Station> stations;

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

  showStation(Station? station) async {
    if (station != null) {
      Navigator.pushNamed(context, "/station", arguments: {
        "station": station,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    category = data["category"];
    stations = data["stations"];

    return Scaffold(
        body: Column(
            children: [
              const SizedBox(height: 60.0),
              Container(
                height: 80.0,
                color: ThemeConfig.darkBGSecondary,
                child: Center(
                  child: Text(
                      category,
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: List.generate(stations.length, (int index) {
                    return GestureDetector(
                      onTap: () => showStation(stations.elementAt(index)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: Colors.white,
                                child: stations.elementAt(index).cover != null ? FadeInImage.assetNetwork(
                                    placeholder: 'images/stationPlaceholder.png',
                                    image: stations.elementAt(index).cover ?? "invalid",
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'images/stationPlaceholder.png',
                                          height: 70.0,
                                          width: 70.0,
                                          fit: BoxFit.contain);
                                    },
                                    height: 70.0,
                                    width: 70.0,
                                    fit: BoxFit.contain
                                ) : Image.asset(
                                    'images/stationPlaceholder.png',
                                    height: 70.0,
                                    width: 70.0,
                                    fit: BoxFit.contain
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                  stations.elementAt(index).name ?? "",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: ThemeConfig.darkAccentPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                Text(
                                    stations.elementAt(index).status?.currently_playing_song ?? ""),
                                Text(
                                    stations.elementAt(index).status?.currently_playing_song ?? "",
                                    style: TextStyle(
                                        color: ThemeConfig.darkIcons,
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                ),
                              ]
                            ),
                          ),
                          const SizedBox(width: 20.0)
                        ],
                      ),
                    );
                  }),
                ),
              )
            ]
        ),
    );
  }
}

