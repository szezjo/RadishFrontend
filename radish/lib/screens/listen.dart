import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radish/custom_widgets/catalogues_slider.dart';
import 'package:radish/models/catalogues.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/custom_widgets/station_slider.dart';
import 'package:radish/models/station.dart';

class ListenPage extends StatefulWidget {
  const ListenPage({Key? key}) : super(key: key);

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {

  List<Station>? favStations;
  List<Station>? recentStations;
  List<Station>? checkStations;
  Catalogues? cataloguesStations;
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


  getStationsLists() async {
    if (user == null) {
      print("no user set");
      return;
    }

    List<List<dynamic>> stationsFetched = [];
    print("${user?.token} TOKEN");

    List<String> endpoints = ["get_favourites", "get_recently_played", "get_check_this_out"];
    for (int i = 0; i < endpoints.length; i++) {
        final response = await http.post(
            Uri.parse('https://radish-app.herokuapp.com/user/${endpoints.elementAt(i)}'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'token': user?.token
            })
        );

      if (response.statusCode != 200) {
        print("${response.statusCode} COULDN'T GET ${endpoints.elementAt(i)}");
        print("${jsonDecode(response.body)}");
        return;
      }

      print("${response.statusCode} GOT ${endpoints.elementAt(i)}");
      var stationsJson = jsonDecode(response.body);
      List<dynamic>? stationsJ = stationsJson != null ? List.from(stationsJson) : null;
      if (stationsJ == null) {
        print("couldnt get stations from json");
        return;
      }

      stationsFetched.add(stationsJ);
    }

    setState(() {
      favStations = stationsFetched[0].map((station) => Station.fromJson(station)).toList();
      recentStations = stationsFetched[1].map((station) => Station.fromJson(station)).toList();
      checkStations = stationsFetched[2].map((station) => Station.fromJson(station)).toList();
    });
  }

  getCategoryList() async {
   String endpointUrl = "get_katalogi_ziom";
    final response = await http.get(
        Uri.parse('https://radish-app.herokuapp.com/radio/$endpointUrl'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T GET $endpointUrl");
      print("${jsonDecode(response.body)}");
      return;
    }

    print("${response.statusCode} GOT $endpointUrl");
    var cataloguesJson = jsonDecode(response.body);

    setState(() {
      cataloguesStations = Catalogues.fromJson(cataloguesJson);
    });
  }

  setupApp() async {
    await getUserData();
    await getStationsLists();
    await getCategoryList();
  }

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: const DecorationImage(
                  alignment: Alignment.topCenter,
                    image: AssetImage("images/headerBg.png"),
                    fit: BoxFit.contain
                ),
              ),
            ),
            SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const Text(
                              "Listen",
                              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 60.0),
                            StationSlider(title: "Your favourites", items: favStations),
                            StationSlider(title: "Recently played", items: recentStations),
                            StationSlider(title: "Check this out", items: checkStations),
                            CatalogueSlider(catalogue: cataloguesStations),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        )
    );
   }
}

