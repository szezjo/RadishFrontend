class User {

  Profile profile;
  List<String> following;
  List<String> followers;
  Status status;
  Settings settings;
  SongsStat songs;
  StationsStat stations;


  User({required this.profile, required this.following, required this.followers, required this.status, required this.settings,
  required this.songs, required this.stations});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        profile: json["profile"],
        following: json["following"],
        followers: json["followers"],
        status: json["status"],
        settings: json["settings"],
        songs: json["songs"],
        stations: json["stations"],
    );
  }
}

class QualitySettings {
  int preffered_bitrate;
  bool download_covers;

  QualitySettings({required this.preffered_bitrate, required this.download_covers});
}

class Quality {
  QualitySettings wifi;
  QualitySettings roaming;

  Quality({required this.wifi, required this.roaming});
}

class Integrations {
  String token;
  Integrations({required this.token});
}

class Settings {
  Map<String, Integrations> integrations;
  Map<String, Quality> quality;

  Settings({required this.integrations, required this.quality});
}

class Song {
  String title;

  Song({required this.title});
}


class Status {
  bool online;
  Song currently_playing;

  Status({required this.online, required this.currently_playing});
}

class SongsStat {
  List<String> discovered;
  List<String> recently_played;

  SongsStat({required this.discovered, required this.recently_played});
}

class StationsStat {
  List<String> favourites;
  List<String> recently_played;

  StationsStat({required this.favourites, required this.recently_played});
}

class Profile {
  String username;
  String avatar;
  String password_hash;
  String display_name;
  String email_address;

  Profile({required this.username, required this.avatar, required this.password_hash, required this.display_name,
  required this.email_address});
}