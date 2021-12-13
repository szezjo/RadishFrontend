// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogues.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalogues _$CataloguesFromJson(Map<String, dynamic> json) => Catalogues(
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
          .toList(),
      decades: (json['decades'] as List<dynamic>?)
          ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
          .toList(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CataloguesToJson(Catalogues instance) =>
    <String, dynamic>{
      'countries': instance.countries?.map((e) => e.toJson()).toList(),
      'decades': instance.decades?.map((e) => e.toJson()).toList(),
      'genres': instance.genres?.map((e) => e.toJson()).toList(),
    };

Label _$LabelFromJson(Map<String, dynamic> json) => Label(
      stations: (json['stations'] as List<dynamic>?)
          ?.map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..label = json['label'] as String?;

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      'label': instance.label,
      'stations': instance.stations?.map((e) => e.toJson()).toList(),
    };
