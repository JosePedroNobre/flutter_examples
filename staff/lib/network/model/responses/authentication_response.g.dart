// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponse _$AuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return AuthenticationResponse(
      accessToken: json['accessToken'] as String,
      domain: json['domain'] == null
          ? null
          : Domain.fromJson(json['domain'] as Map<String, dynamic>),
      refreshToken: json['refreshToken'] as String,
      staff: json['staff'] == null
          ? null
          : Staff.fromJson(json['staff'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AuthenticationResponseToJson(
        AuthenticationResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'domain': instance.domain,
      'staff': instance.staff
    };
