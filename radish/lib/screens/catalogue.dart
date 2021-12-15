import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radish/models/catalogues.dart';
import 'package:radish/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:radish/models/user.dart';
import 'package:radish/models/station.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {

  late Catalogues catalogue;
  late bool searching;

  String? categoryChosen;
  User? user;
  List<Station>? foundStations;

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

  showStations(Label label) {
    Navigator.pushNamed(context, "/stations", arguments: {
      "category": label.label,
      "stations": label.stations
    });
  }

  showStation(Station? station) async {
    if (station != null) {
      Navigator.pushNamed(context, "/station", arguments: {
        "station": station,
      });
    }
  }

  Widget _child = SizedBox(height: 60.0);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        categoryChosen = data["catalogueName"];
      });
    });
    searching = false;
    getUserData();
    setChild();
  }

  setChild() {
    setState(() {
      searching = false;
      _child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                flex: 8,
                child: Text(
                  "Catalogue",
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => showSearchBar(),
                  icon: Icon(
                    Icons.search_rounded,
                    color: ThemeConfig.darkIcons,
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: buttonStyle("Genres", categoryChosen),
                    child: const Text("Genres"),
                    onPressed: () => {switchCategory("Genres")}
                ),
                TextButton(
                    style: buttonStyle("Decades", categoryChosen),
                    child: const Text("Decades"),
                    onPressed: () => {switchCategory("Decades")}
                ),
                TextButton(
                    style: buttonStyle("Countries", categoryChosen),
                    child: const Text("Countries"),
                    onPressed: () => {switchCategory("Countries")}
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  showSearchBar() {
    setState(() {
      _child = Row(
        children: [
          Expanded(
            flex: 8,
            child: TextField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      )
                  ),
                  hintText: 'Enter station name'
              ),

              onChanged: (text) async {
                List<Station> f = await fetchStations(text);
                setState(() {
                  foundStations = f;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => showSearchBar(),
              icon: Icon(
                Icons.search_rounded,
                color: ThemeConfig.darkIcons,
                size: 24.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => {
                setChild()
              },
              icon: Icon(
                Icons.close_rounded,
                color: ThemeConfig.darkIcons,
                size: 24.0,
              ),
            ),
          ),
        ],
      );
      searching = true;
    });
  }

  fetchStations(String name) async {
    if (name == "") {
      return <Station>[];
    }
    final response = await http.post(
      Uri.parse('https://radish-app.herokuapp.com/radio/find_external'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'filter_name': "name",
        'filter_value': name,
      }),
    );
    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T GET STATIONS BY $name");
      print("${jsonDecode(response.body)}");
      return;
    }

    print("${response.statusCode} GOT radio/find_external BY -$name-");
    var stationsJson = jsonDecode(response.body);
    List<dynamic>? stationsJ = stationsJson != null ? List.from(stationsJson) : null;
    if (stationsJ == null) {
      print("couldnt get stations from json");
      return;
    }

    List<Station> fetchedStations = stationsJ.map((station) => Station.fromJson(station)).toList();
    return fetchedStations;
  }

  switchCategory(String category) {
    String newCategory = category;
    if (categoryChosen == category) {
      newCategory = "";
    }
    setState(() {
      categoryChosen = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    catalogue = data["catalogue"];

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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: _child,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                        bottom: BorderSide(
                        color: ThemeConfig.darkDivider,
                      ),)
                    ),
                  ),
                  Expanded(
                      child: searching ? radioList(foundStations, showStation) : getList(catalogue, categoryChosen!, showStations)
                  )
                ],
              )
            ]
        )
    );
   }
}

Widget radioList(List<Station>? stations, Function(Station) onTap) {
  return ListView(
    padding: EdgeInsets.zero,
    scrollDirection: Axis.vertical,
    children: List.generate(stations?.length ?? 0, (int index) {
      return GestureDetector(
        onTap: () => onTap(stations!.elementAt(index)),
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
                    child: stations!.elementAt(index).cover != null ? FadeInImage.assetNetwork(
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
        ),
      );
    }),
  );
}

ButtonStyle buttonStyle(String category, String? chosenCategory) {
  bool chosen = category == chosenCategory;
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(color: ThemeConfig.darkAccentPrimary, width: 3.0)
        )
    ),
    fixedSize: MaterialStateProperty.all(const Size.fromWidth(100)),
    overlayColor: MaterialStateProperty.all(ThemeConfig.darkAccentPrimary),
    foregroundColor: chosen ? MaterialStateProperty.all(ThemeConfig.darkBGSecondary) : MaterialStateProperty.all(Colors.white),
    backgroundColor: chosen ? MaterialStateProperty.all(ThemeConfig.darkAccentPrimary) : null
  );
}

Widget getList(Catalogues catalogue, String categoryChosen, Function(Label) onTap) {
  if (categoryChosen == "Genres") {
    return labelList(catalogue.genres, onTap);
  } else if (categoryChosen == "Decades") {
    return labelList(catalogue.decades, onTap);
  } else if (categoryChosen == "Countries") {
    return labelList(catalogue.countries, onTap);
  } else {
    var allLabels = [...?catalogue.genres, ...?catalogue.decades, ...?catalogue.countries];
    return labelList(allLabels, onTap);
  }
}

Widget labelList(List<Label>? labels, Function(Label) onTap) {
  labels!.sort((a, b) => a.label!.compareTo(b.label!));
  return ListView(
    padding: EdgeInsets.zero,
    scrollDirection: Axis.vertical,
    children: List.generate(labels.length, (int index) {
      return GestureDetector(
        onTap: () => onTap(labels.elementAt(index)),
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
              color: ThemeConfig.darkDivider,
            ),)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                labels.elementAt(index).label != null ? '${labels.elementAt(index).label!} (${labels.elementAt(index).stations?.length ?? 0})' : "unknown"
              ),
            ),
          )
        ),
      );
    }),
  );
}

