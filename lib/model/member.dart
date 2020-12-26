import 'package:flutter/animation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'member.g.dart';

@JsonSerializable()
class Member {
  String name;
  String username;
  String email;

  Member({
    this.name,
    this.username,
    this.email,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
