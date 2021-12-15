import 'package:flutter/material.dart';
import 'package:radish/models/station.dart';
import 'package:radish/theme/theme_config.dart';

class StationSlider extends StatefulWidget {
  final String title;
  final List<Station>? items;

  const StationSlider({
    Key? key, required this.title, required this.items}) : super(key: key);


  @override
  State<StationSlider> createState() => _StationSliderState();
}

class _StationSliderState extends State<StationSlider> {


  showAll() async {
    if (widget.items != null) {
      Navigator.pushNamed(context, "/stations", arguments: {
        "category": widget.title,
        "stations": widget.items
      });
    }
  }

  showStation(Station? station) async {
    if (station != null) {
      Navigator.pushNamed(context, "/station", arguments: {
        "station": station,
      }).then((value) => setState(() {}));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  widget.title,
                style: const TextStyle(fontSize: 18.0)
              ),
              GestureDetector(
                onTap: () => showAll(),
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
              children: List.generate(widget.items?.length ?? 0, (int index) {
                return GestureDetector(
                  onTap: () => showStation(widget.items?.elementAt(index)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.white,
                        child: widget.items?.elementAt(index).cover != null ? FadeInImage.assetNetwork(
                            placeholder: 'images/stationPlaceholder.png',
                            image: widget.items?.elementAt(index).cover ?? "invalid",
                            imageErrorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  'images/stationPlaceholder.png',
                                  height: 90.0,
                                  width: 90.0,
                                  fit: BoxFit.contain);
                            },
                            height: 90.0,
                            width: 90.0,
                            fit: BoxFit.contain
                        ) : Image.asset(
                            'images/stationPlaceholder.png',
                            height: 90.0,
                            width: 90.0,
                            fit: BoxFit.contain
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}