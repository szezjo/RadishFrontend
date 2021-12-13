import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radish/models/catalogues.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/custom_widgets/station_slider.dart';

class CataloguePage extends StatefulWidget {

  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {

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
              SizedBox(height: 60.0),
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
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.genres.toString(),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.decades.toString(),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
              Text(
                  catalogue.countries.toString(),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
              ),
      ]
        ),
    );
  }
}

