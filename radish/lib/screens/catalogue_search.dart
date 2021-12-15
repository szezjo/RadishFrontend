import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/catalogues.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';

class CatalogueSearchPage extends StatefulWidget {

  const CatalogueSearchPage({Key? key}) : super(key: key);

  @override
  State<CatalogueSearchPage> createState() => _CatalogueSearchPageState();
}

class _CatalogueSearchPageState extends State<CatalogueSearchPage> {

  late Catalogues catalogue;
  late String catalogueName;

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
    catalogue = data["catalogue"];
    catalogueName = data["catalogueName"];

    return Scaffold(
        body: Column(
            children: [
              const SizedBox(height: 60.0),
              Container(
                height: 80.0,
                color: ThemeConfig.darkBGSecondary,
                child: const Center(
                  child: Text(
                      "Catalogues WIP",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              Text(
                  catalogueName,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.genres![0].label!,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.decades![0].label!,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.countries![0].label!,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
      ]
        ),
    );
  }
}
