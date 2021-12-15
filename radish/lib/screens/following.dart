import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';

class FollowingPage extends StatefulWidget {

  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        child: user?.profile?.avatar != null &&
                            user?.profile?.avatar != "" ? FadeInImage.assetNetwork(
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: const []
              ),
            )
          ]
      ),
    );
  }
}

