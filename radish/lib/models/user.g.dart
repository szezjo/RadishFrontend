// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
      songs: json['songs'] == null
          ? null
          : SongsStat.fromJson(json['songs'] as Map<String, dynamic>),
      stations: json['stations'] == null
          ? null
          : StationsStat.fromJson(json['stations'] as Map<String, dynamic>),
      token: json['token'] as String,
    )..activity = (json['activity'] as List<dynamic>?)
        ?.map((e) => Log.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'profile': instance.profile?.toJson(),
      'following': instance.following,
      'followers': instance.followers,
      'status': instance.status?.toJson(),
      'settings': instance.settings?.toJson(),
      'songs': instance.songs?.toJson(),
      'stations': instance.stations?.toJson(),
      'activity': instance.activity?.map((e) => e.toJson()).toList(),
      'token': instance.token,
    };

QualitySettings _$QualitySettingsFromJson(Map<String, dynamic> json) =>
    QualitySettings(
      preffered_bitrate: json['preffered_bitrate'] as int?,
      download_covers: json['download_covers'] as bool?,
    );

Map<String, dynamic> _$QualitySettingsToJson(QualitySettings instance) =>
    <String, dynamic>{
      'preffered_bitrate': instance.preffered_bitrate,
      'download_covers': instance.download_covers,
    };

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      timestamp: json['timestamp'] as String?,
      did: json['did'] as String?,
      radio: json['radio'] == null
          ? null
          : Station.fromJson(json['radio'] as Map<String, dynamic>),
      song: json['song'] as String?,
    );

Map<String, dynamic> _$LogToJson(Log instance) => <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'timestamp': instance.timestamp,
      'did': instance.did,
      'radio': instance.radio?.toJson(),
      'song': instance.song,
    };

Quality _$QualityFromJson(Map<String, dynamic> json) => Quality(
      wifi: json['wifi'] == null
          ? null
          : QualitySettings.fromJson(json['wifi'] as Map<String, dynamic>),
      roaming: json['roaming'] == null
          ? null
          : QualitySettings.fromJson(json['roaming'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QualityToJson(Quality instance) => <String, dynamic>{
      'wifi': instance.wifi?.toJson(),
      'roaming': instance.roaming?.toJson(),
    };

Spotify _$SpotifyFromJson(Map<String, dynamic> json) => Spotify(
      token: json['_token'] as String?,
    );

Map<String, dynamic> _$SpotifyToJson(Spotify instance) => <String, dynamic>{
      '_token': instance.token,
    };

Notion _$NotionFromJson(Map<String, dynamic> json) => Notion(
      token: json['_token'] as String?,
    );

Map<String, dynamic> _$NotionToJson(Notion instance) => <String, dynamic>{
      '_token': instance.token,
    };

Integrations _$IntegrationsFromJson(Map<String, dynamic> json) => Integrations(
      notion: json['notion'] == null
          ? null
          : Notion.fromJson(json['notion'] as Map<String, dynamic>),
      spotify: json['spotify'] == null
          ? null
          : Spotify.fromJson(json['spotify'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IntegrationsToJson(Integrations instance) =>
    <String, dynamic>{
      'notion': instance.notion?.toJson(),
      'spotify': instance.spotify?.toJson(),
    };

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      integrations: json['integrations'] == null
          ? null
          : Integrations.fromJson(json['integrations'] as Map<String, dynamic>),
      quality: json['quality'] == null
          ? null
          : Quality.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'integrations': instance.integrations?.toJson(),
      'quality': instance.quality?.toJson(),
    };

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      title: json['title'] as String?,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'title': instance.title,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      last_seen: json['last_seen'] as String?,
      currently_playing: json['currently_playing'] as String?,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'last_seen': instance.last_seen,
      'currently_playing': instance.currently_playing,
    };

SongsStat _$SongsStatFromJson(Map<String, dynamic> json) => SongsStat(
      discovered: (json['discovered'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recently_played: (json['recently_played'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SongsStatToJson(SongsStat instance) => <String, dynamic>{
      'discovered': instance.discovered,
      'recently_played': instance.recently_played,
    };

StationsStat _$StationsStatFromJson(Map<String, dynamic> json) => StationsStat(
      favourites: (json['favourites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recently_played: (json['recently_played'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StationsStatToJson(StationsStat instance) =>
    <String, dynamic>{
      'favourites': instance.favourites,
      'recently_played': instance.recently_played,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      display_name: json['display_name'] as String?,
      email_address: json['email_address'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'display_name': instance.display_name,
      'email_address': instance.email_address,
    };
