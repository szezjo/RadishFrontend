// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowedUser _$FollowedUserFromJson(Map<String, dynamic> json) => FollowedUser(
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FollowedUserToJson(FollowedUser instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'email': instance.email,
      'username': instance.username,
      'status': instance.status?.toJson(),
    };
