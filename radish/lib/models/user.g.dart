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
          ?.map((e) => e as String)
          .toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
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
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'profile': instance.profile?.toJson(),
      'following': instance.following,
      'followers': instance.followers,
      'status': instance.status?.toJson(),
      'settings': instance.settings?.toJson(),
      'songs': instance.songs?.toJson(),
      'stations': instance.stations?.toJson(),
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
      online: json['online'] as bool?,
      currently_playing: json['currently_playing'] == null
          ? null
          : Song.fromJson(json['currently_playing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'online': instance.online,
      'currently_playing': instance.currently_playing?.toJson(),
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
      password_hash: json['password_hash'] as String?,
      display_name: json['display_name'] as String?,
      email_address: json['email_address'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'password_hash': instance.password_hash,
      'display_name': instance.display_name,
      'email_address': instance.email_address,
    };
