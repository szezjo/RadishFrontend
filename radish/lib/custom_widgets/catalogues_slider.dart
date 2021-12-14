import 'package:flutter/material.dart';
import 'package:radish/models/catalogues.dart';
import 'package:radish/theme/theme_config.dart';

class CatalogueSlider extends StatefulWidget {
  final Catalogues? catalogue;

  const CatalogueSlider({
    Key? key, required this.catalogue}) : super(key: key);


  @override
  State<CatalogueSlider> createState() => _CatalogueSliderState();
}

class _CatalogueSliderState extends State<CatalogueSlider> {


  showAll(String catalogueName, Catalogues catalogues) async {
      Navigator.pushNamed(context, "/catalogue", arguments: {
        "catalogue": catalogues,
        "catalogueName": catalogueName
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                  "Catalogue",
                style: TextStyle(fontSize: 18.0)
              ),
              GestureDetector(
                onTap: () => showAll("", widget.catalogue!),
                child: Icon(
                  Icons.arrow_forward,
                  color: ThemeConfig.darkAccentPrimary,
                  size: 18.0,
                ),
              ),
            ]
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
          child: SizedBox(
            height: 90.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => showAll("Genres", widget.catalogue!),
                  child: catalogueItem("images/genresCover.png")
                ),
                GestureDetector(
                    onTap: () => showAll("Decades", widget.catalogue!),
                    child: catalogueItem("images/decadesCover.png")
                ),
                GestureDetector(
                    onTap: () => showAll("Countries", widget.catalogue!),
                    child: catalogueItem("images/countriesCover.png")
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}

Widget catalogueItem(String coverUrl) {

  return Padding(
    padding: const EdgeInsets.only(right: 15.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: Colors.white,
        child: Image.asset(
            coverUrl,
            height: 90.0,
            width: 90.0,
            fit: BoxFit.contain
        ),
      ),
    ),
  );
}