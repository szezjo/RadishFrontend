import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/theme/theme_config.dart';
import 'package:palette_generator/palette_generator.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  List<Log>? activityLog;
  User? user;

  goToDiscoveries() async {
      Navigator.pushNamed(context, "/discoveries", arguments: {
        "title": "Discoveries",
        "songs": user?.songs?.discovered,
      });
  }

  goToRecently() async {
      Navigator.pushNamed(context, "/recently", arguments: {
        "title": "Recently played",
        "songs": user?.songs?.recently_played,
      });
  }

  goToFollowing() async {
    Navigator.pushNamed(context, "/following");
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
    try {
      if (user?.profile?.avatar == null) {
        return Colors.white;
      }
      final PaletteGenerator paletteGenerator = await PaletteGenerator
          .fromImageProvider(NetworkImage(user!.profile!.avatar!), timeout: const Duration(seconds: 1));
      return paletteGenerator.dominantColor?.color ?? Colors.white;
    } catch (err) {
      return Colors.white;
    }
  }

  getActivityFeed() async {
    if (user == null) {
      print("no user set");
      return;
    }

    print("${user?.token} TOKEN");

    String endpointUrl = "get_followed_activity_logs";

    final response = await http.post(
        Uri.parse('https://radish-scening.herokuapp.com/user/$endpointUrl'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'token': user?.token
        })
    );

    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T GET $endpointUrl");
      print("${jsonDecode(response.body)}");
      return;
    }

    print("${response.statusCode} GOT $endpointUrl");
    var activitiesJson = jsonDecode(response.body);
    List<dynamic>? activitiesJ = activitiesJson != null ? List.from(activitiesJson) : null;
    if (activitiesJ == null) {
      print("couldnt get activity logs from json");
      return;
    }

    setState(() {
      activityLog = activitiesJ.map((log) => Log.fromJson(log)).toList();
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
                  Column( // 2 BACKGROUND COVER RECTANGLES
                    children: [
                      const SizedBox(height: 60.0),
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
                        height: 150.0,
                        color: ThemeConfig.darkBGSecondary,
                      )
                    ],
                  ),
                  Positioned( // THE AVATAR & NAME & BUTTONS
                    top: 95.0,
                    left: 20.0,
                    width: MediaQuery.of(context).size.width - 40.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
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
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                            child: Text(
                                user?.profile?.display_name ?? "",
                                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: goToFollowing,
                            icon: Icon(
                              Icons.people_rounded,
                              color: ThemeConfig.darkIcons,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => print("settings"),
                            icon: Icon(
                              Icons.settings_rounded,
                              color: ThemeConfig.darkIcons,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 30.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: ThemeConfig.darkAccentPrimary, width: 3.0)
                                  )
                              ),
                              fixedSize: MaterialStateProperty.all(const Size.fromWidth(140)),
                              overlayColor: MaterialStateProperty.all(ThemeConfig.darkAccentPrimary),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text("Discoveries"),
                            onPressed: goToDiscoveries,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: ThemeConfig.darkAccentPrimary, width: 3.0)
                                  )
                              ),
                              fixedSize: MaterialStateProperty.all(const Size.fromWidth(140)),
                              overlayColor: MaterialStateProperty.all(ThemeConfig.darkAccentPrimary),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text("Recently played"),
                            onPressed: goToRecently,
                          ),
                        ],
                      ),
                    ),)
                ]
            ),
            Expanded(
                child: activityList(activityLog, user)
            )
          ]
      ),
    );
  }
}

Widget activityList(List <Log>? activityLog, User? user) {

  isLiked(Log log) {
    if (log.radio != null) {
      return user!.stations!.favourites!.contains(log.radio!.api_id);
    } else if (log.song != "" && log.song != null){
      return user!.songs!.discovered!.contains(log.song);
    } else {
      return false;
    }
  }


  return ListView(
    padding: EdgeInsets.zero,
    scrollDirection: Axis.vertical,
    children: List.generate(activityLog?.length ?? 0, (int index) {
      return GestureDetector(
        onDoubleTap: () => print("really liked ${activityLog!.elementAt(index).song}"),
        onTap: () => print("listen to ${activityLog!.elementAt(index).radio!.name}"),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemeConfig.darkDivider,
                ),)
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Colors.white,
                    child: activityLog?.elementAt(index).avatar != null ? FadeInImage.assetNetwork(
                        placeholder: 'images/avatarPlaceholder.png',
                        image: activityLog?.elementAt(index).avatar ?? "invalid",
                        imageErrorBuilder:
                            (context, error, stackTrace) {
                          return Image.asset(
                              'images/avatarPlaceholder.png',
                              height: 70.0,
                              width: 70.0,
                              fit: BoxFit.contain);
                        },
                        height: 70.0,
                        width: 70.0,
                        fit: BoxFit.contain
                    ) : Image.asset(
                        'images/avatarPlaceholder.png',
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
                        activityLog!.elementAt(index).username ?? "",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: ThemeConfig.darkAccentPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      Text(
                          activityLog.elementAt(index).did ?? ""),
                      Text(
                        activityLog.elementAt(index).song ?? (activityLog.elementAt(index).radio?.name ?? ""),
                        style: TextStyle(
                          color: ThemeConfig.darkIcons,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]
                ),
              ),
              IconButton(
                onPressed: () => print(activityLog.elementAt(index).did),
                icon: isLiked(activityLog.elementAt(index)) ?
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
            ],
          ),
        ),
      );
    }),
  );
}

