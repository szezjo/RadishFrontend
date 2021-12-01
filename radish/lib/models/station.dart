import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

@JsonSerializable(explicitToJson: true)
class Station {

  String? name;
  String? cover;
  String? country;
  String? language;
  String? tags;
  Streams? streams;
  Popularity? popularity;
  Status? status;
  String? api_id;
  List<String>? history;

  Station(
      {required this.name,
      required this.cover,
      required this.country,
      required this.language,
      required this.tags,
      required this.streams,
      required this.popularity,
      required this.status,
      required this.api_id,
      required this.history});

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Streams {

  String? url;
  String? codec;
  int? bitrate;
  int? status;


  Streams(
      {required this.url,
        required this.codec,
        required this.bitrate,
        required this.status});

  factory Streams.fromJson(Map<String, dynamic> json) => _$StreamsFromJson(json);
  Map<String, dynamic> toJson() => _$StreamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Popularity {

  int? likes;
  int? last_24h;
  int? listeners_in_country;


  Popularity(
      {required this.likes,
        required this.last_24h,
        required this.listeners_in_country});

  factory Popularity.fromJson(Map<String, dynamic> json) => _$PopularityFromJson(json);
  Map<String, dynamic> toJson() => _$PopularityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Status {

  String? currently_playing_song;
  int? listeners;


  Status(
      {required this.currently_playing_song,
        required this.listeners});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}