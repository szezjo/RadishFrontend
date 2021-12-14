import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/custom_widgets/station_slider.dart';

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

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    title = data["title"];
    songs = data["songs"];

    return Scaffold(
        body: Column(
            children: [
              SizedBox(height: 60.0),
              Container(
                height: 80.0,
                color: ThemeConfig.darkBGSecondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          child: user?.profile?.avatar != null ? FadeInImage.assetNetwork(
                              placeholder: 'images/avatarPlaceholder.png',
                              image: user!.profile!.avatar!,
                              height: 50.0,
                              width: 50.0,
                              fit: BoxFit.contain
                          ) : Image.asset(
                              'images/avatarPlaceholder.png',
                              height: 50.0,
                              width: 50.0,
                              fit: BoxFit.contain
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                            title,
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
                        ),
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
                      onDoubleTap: () => print("liked ${songs.elementAt(index)}"),
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
                                onPressed: () => print("faved ${songs.elementAt(index)}"),
                                icon: isSongLiked(songs.elementAt(index)) ?
                                Icon(
                                  Icons.favorite_rounded,
                                  color: ThemeConfig.darkAccentPrimary,
                                  size: 24.0,
                                ) :
                                Icon(
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
            ]
        ),
    );
  }
}

