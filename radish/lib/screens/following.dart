import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/followed_user.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class FollowingPage extends StatefulWidget {

  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  late String category;
  late List<Station> stations;

  User? user;
  List<FollowedUser>? followedUsers;

  getTimeAgo(String? timestamp) {
    try {
      if (timestamp != null) {
        final moment = DateFormat('dd-MM-yy HH:mm').parse(timestamp);
        return timeago.format(moment);
      } else {
        return "offline";
      }
    } catch(e) {
      return "offline";
    }
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

  getFollowed() async {
    String endpointUrl = "get_followed_users";
    print(user?.token);
    final response = await http.post(
        Uri.parse('https://radish-app.herokuapp.com/user/$endpointUrl'),
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
    var usersJson = jsonDecode(response.body);
    List<dynamic>? usersJ = usersJson != null ? List.from(usersJson) : null;
    if (usersJ == null) {
      print("couldnt get stations from json");
      return;
    }

    List<FollowedUser> fetchedUsers = usersJ.map((user) => FollowedUser.fromJson(user)).toList();

    setState(() {
      followedUsers = fetchedUsers;
    });
  }

  setupApp() async {
    await getUserData();
    await getFollowed();
  }

  @override
  void initState() {
    super.initState();
    setupApp();
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
    return Scaffold(
      body: Column(
          children: [
            const SizedBox(height: 60.0),
            Container(
              height: 80.0,
              color: ThemeConfig.darkBGSecondary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            child: user?.profile?.avatar != null && user?.profile?.avatar != "" ? FadeInImage.assetNetwork(
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
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                              "Following",
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => print("search"),
                        icon: Icon(
                          Icons.search_rounded,
                          color: ThemeConfig.darkIcons,
                          size: 24.0,
                        )
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: List.generate(followedUsers?.length ?? 0, (int index) {
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ThemeConfig.darkDivider,
                            ),
                          ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: Colors.white,
                                child: followedUsers?.elementAt(index).avatar != null
                                    && followedUsers?.elementAt(index).avatar != "" ?
                                FadeInImage.assetNetwork(
                                    placeholder: 'images/avatarPlaceholder.png',
                                    image: followedUsers?.elementAt(index).avatar ?? "invalid",
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
                                    followedUsers?.elementAt(index).username ?? "",
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  followedUsers?.elementAt(index).status?.currently_playing != null ?
                                    Text(
                                      followedUsers?.elementAt(index).status?.currently_playing ?? "",
                                      style: TextStyle(
                                        color: ThemeConfig.darkAccentSecondary,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ) :
                                    Text(
                                      getTimeAgo(followedUsers?.elementAt(index).status?.last_seen),
                                      style: TextStyle(
                                        color: ThemeConfig.darkInactivePrimary,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ]
                            ),
                          ),
                          IconButton(
                            onPressed: () => print(followedUsers?.elementAt(index).username ?? "unknown"),
                            icon: Icon(
                              Icons.person_remove_alt_1_rounded,
                              color: ThemeConfig.darkAccentPrimary,
                              size: 24.0,
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            )
          ]
      ),
    );
  }
}

