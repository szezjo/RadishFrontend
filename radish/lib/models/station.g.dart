// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      tags: json['tags'] as String?,
      streams: json['streams'] == null
          ? null
          : Streams.fromJson(json['streams'] as Map<String, dynamic>),
      popularity: json['popularity'] == null
          ? null
          : Popularity.fromJson(json['popularity'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      api_id: json['api_id'] as String?,
      history:
          (json['history'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'name': instance.name,
      'cover': instance.cover,
      'country': instance.country,
      'language': instance.language,
      'tags': instance.tags,
      'streams': instance.streams?.toJson(),
      'popularity': instance.popularity?.toJson(),
      'status': instance.status?.toJson(),
      'api_id': instance.api_id,
      'history': instance.history,
    };

Streams _$StreamsFromJson(Map<String, dynamic> json) => Streams(
      url: json['url'] as String?,
      codec: json['codec'] as String?,
      bitrate: json['bitrate'] as int?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$StreamsToJson(Streams instance) => <String, dynamic>{
      'url': instance.url,
      'codec': instance.codec,
      'bitrate': instance.bitrate,
      'status': instance.status,
    };

Popularity _$PopularityFromJson(Map<String, dynamic> json) => Popularity(
      likes: json['likes'] as int?,
      last_24h: json['last_24h'] as int?,
      listeners_in_country: json['listeners_in_country'] as int?,
    );

Map<String, dynamic> _$PopularityToJson(Popularity instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'last_24h': instance.last_24h,
      'listeners_in_country': instance.listeners_in_country,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      currently_playing_song: json['currently_playing_song'] as String?,
      listeners: json['listeners'] as int?,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'currently_playing_song': instance.currently_playing_song,
      'listeners': instance.listeners,
    };
