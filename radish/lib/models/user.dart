import 'package:json_annotation/json_annotation.dart';
import 'package:radish/models/station.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {

  Profile? profile;
  List<String?>? following;
  List<String?>? followers;
  Status? status;
  Settings? settings;
  SongsStat? songs;
  StationsStat? stations;
  List<Log>? activity;
  String token;


  User({required this.profile, required this.following, required this.followers, required this.status, required this.settings,
  required this.songs, required this.stations, required this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}

@JsonSerializable(explicitToJson: true)
class QualitySettings {
  int? preffered_bitrate;
  bool? download_covers;

  QualitySettings({required this.preffered_bitrate, required this.download_covers});

  factory QualitySettings.fromJson(Map<String, dynamic> json) => _$QualitySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$QualitySettingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Log {
  String? username;
  String? avatar;
  String? timestamp;
  String? did;
  Station? radio;
  String? song;

  Log({required this.username, required this.avatar, required this.timestamp,
    required this.did, required this.radio, required this.song});

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);
  Map<String, dynamic> toJson() => _$LogToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Quality {
  QualitySettings? wifi;
  QualitySettings? roaming;

  Quality({required this.wifi, required this.roaming});

  factory Quality.fromJson(Map<String, dynamic> json) => _$QualityFromJson(json);
  Map<String, dynamic> toJson() => _$QualityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Spotify {
  @JsonKey(name: '_token')
  String? token;

  Spotify({required this.token});

  factory Spotify.fromJson(Map<String, dynamic> json) => _$SpotifyFromJson(json);
  Map<String, dynamic> toJson() => _$SpotifyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Notion {
  @JsonKey(name: '_token')
  String? token;

  Notion({required this.token});

  factory Notion.fromJson(Map<String, dynamic> json) => _$NotionFromJson(json);
  Map<String, dynamic> toJson() => _$NotionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Integrations {
  Notion? notion;
  Spotify? spotify;

  Integrations({required this.notion, required this.spotify});

  factory Integrations.fromJson(Map<String, dynamic> json) => _$IntegrationsFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Settings {
  Integrations? integrations;
  Quality? quality;

  Settings({required this.integrations, required this.quality});

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Song {
  String? title;

  Song({required this.title});

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
  Map<String, dynamic> toJson() => _$SongToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Status {
  String? last_seen;
  String? currently_playing;

  Status({required this.last_seen, required this.currently_playing});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SongsStat {
  List<String>? discovered;
  List<String>? recently_played;

  SongsStat({required this.discovered, required this.recently_played});

  factory SongsStat.fromJson(Map<String, dynamic> json) => _$SongsStatFromJson(json);
  Map<String, dynamic> toJson() => _$SongsStatToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StationsStat {
  List<String>? favourites;
  List<String>? recently_played;

  StationsStat({required this.favourites, required this.recently_played});

  factory StationsStat.fromJson(Map<String, dynamic> json) => _$StationsStatFromJson(json);
  Map<String, dynamic> toJson() => _$StationsStatToJson(this);
}

@JsonSerializable(explicitToJson: true, nullable: true)
class Profile {
  String? username;
  String? avatar;
  String? display_name;
  String? email_address;

  Profile({required this.username, required this.avatar, required this.display_name, required this.email_address});

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}