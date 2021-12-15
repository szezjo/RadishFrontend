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

  String? categoryChosen;
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
    Future.delayed(Duration.zero, () {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        categoryChosen = data["catalogueName"];
      });
    });
    getUserData();
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
                    child: Column(
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
                                onPressed: () => print("lookfor"),
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
                                onPressed: () => print("sth"),
                                icon: Icon(
                                  Icons.open_in_new_rounded,
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
                      child: getList(catalogue, categoryChosen!)
                  )
                ],
              )
            ]
        )
    );
   }
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

Widget getList(Catalogues catalogue, String categoryChosen) {
  if (categoryChosen == "Genres") {
    return labelList(catalogue.genres);
  } else if (categoryChosen == "Decades") {
    return labelList(catalogue.decades);
  } else if (categoryChosen == "Countries") {
    return labelList(catalogue.countries);
  } else {
    var allLabels = [...?catalogue.genres, ...?catalogue.decades, ...?catalogue.countries];
    return labelList(allLabels);
  }
}

Widget labelList(List<Label>? labels) {
  labels!.sort((a, b) => a.label!.compareTo(b.label!));
  return ListView(
    padding: EdgeInsets.zero,
    scrollDirection: Axis.vertical,
    children: List.generate(labels.length, (int index) {
      return GestureDetector(
        onTap: () => print("look into ${labels.elementAt(index)}"),
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
                labels.elementAt(index).label ?? "unknown"
              ),
            ),
          )
        ),
      );
    }),
  );
}

