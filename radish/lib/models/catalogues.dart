import 'package:json_annotation/json_annotation.dart';
import 'package:radish/models/station.dart';

part 'catalogues.g.dart';

@JsonSerializable(explicitToJson: true)
class Catalogues {

  List<Label>? countries;
  List<Label>? decades;
  List<Label>? genres;

  Catalogues(
      {required this.countries,
      required this.decades,
      required this.genres});

  factory Catalogues.fromJson(Map<String, dynamic> json) => _$CataloguesFromJson(json);
  Map<String, dynamic> toJson() => _$CataloguesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Label {

  String? label;
  List<Station>? stations;


  Label({required this.stations});

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);
  Map<String, dynamic> toJson() => _$LabelToJson(this);
}