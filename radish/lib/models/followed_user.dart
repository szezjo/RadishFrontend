import 'package:json_annotation/json_annotation.dart';
import 'package:radish/models/user.dart';

part 'followed_user.g.dart';

@JsonSerializable(explicitToJson: true)
class FollowedUser {

  String? avatar;
  String? email;
  String? username;
  Status? status;


  FollowedUser({required this.avatar, required this.email, required this.username, required this.status});

  factory FollowedUser.fromJson(Map<String, dynamic> json) => _$FollowedUserFromJson(json);
  Map<String, dynamic> toJson() => _$FollowedUserToJson(this);

}