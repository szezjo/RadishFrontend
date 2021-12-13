import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/theme/theme_config.dart';
import 'package:radish/models/station.dart';
import 'package:palette_generator/palette_generator.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  List<dynamic>? activityLog;
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

  Future<Color> getImagePalette () async {
    if (user?.profile?.avatar == null) {
      return Colors.white;
    }
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(NetworkImage(user!.profile!.avatar!),);
    return paletteGenerator.dominantColor?.color ?? Colors.white;
  }


  getActivityFeed() async {
    if (this.user == null) {
      print("no user set");
      return;
    }

    List<dynamic> activitiesFetched = [];
    // print("${this.user?.token} TOKEN");
    //
    // String endpointUrl = "";
    //
    // final response = await http.post(
    //     Uri.parse('https://radish-app.herokuapp.com/user/${endpointUrl}'),
    //     headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode({
    //       'token': this.user?.token
    //     })
    // );
    //
    // if (response.statusCode != 200) {
    //   print("${response.statusCode} COULDN'T GET ${endpointUrl}");
    //   print("${jsonDecode(response.body)}");
    //   return;
    // }
    //
    // print("${response.statusCode} GOT ${endpointUrl}");
    // var activitiesJson = jsonDecode(response.body);
    // List<dynamic>? activitiesJ = activitiesJson != null ? List.from(activitiesJson) : null;
    // if (activitiesJ == null) {
    //   print("couldnt get activities from json");
    //   return;
    // }

    setState(() {
      // activityLog = activitiesJ.map((log) => Log.fromJson(log)).toList();
      activityLog = ["1", "2", "3"];
    });
  }

  setupApp() async {
    await getUserData();
    await getActivityFeed();
  }

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  @override
  Widget build(BuildContext context) {
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
                              );
                            }
                            else {
                              return Container(
                                height: 80.0,
                                color: ThemeConfig.darkBGSecondary,
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
                              user?.profile?.display_name ?? "",
                              style: TextStyle(fontSize: 18.0)),
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
                        child: user?.profile?.avatar != null ? FadeInImage.assetNetwork(
                            placeholder: 'images/avatarPlaceholder.png',
                            image: user!.profile!.avatar!,
                            height: 90.0,
                            width: 90.0,
                            fit: BoxFit.contain
                        ) : Image.asset(
                            'images/avatarPlaceholder.png',
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
                        children: const [
                          Text(
                              "Quality",
                              style: TextStyle(fontSize: 18.0)),
                        ],
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
            Expanded(
                child: activityList(activityLog)
            )
          ]
      ),
    );
  }
}

Widget activityList(List <dynamic>? activityLog) {
  return ListView(
    padding: EdgeInsets.zero,
    scrollDirection: Axis.vertical,
    children: List.generate(activityLog?.length ?? 0, (int index) {
      return GestureDetector(
        onDoubleTap: () => print("liked ${activityLog?.elementAt(index)}"),
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
                  activityLog?.elementAt(index) ?? "",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: ThemeConfig.darkIcons,
                      fontSize: 18.0),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => print("faved ${activityLog?.elementAt(index)}"),
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

