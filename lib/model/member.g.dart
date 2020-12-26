part of 'member.dart';

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String);
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'email': instance.email
    };
