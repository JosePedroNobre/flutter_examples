// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponse _$AuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return AuthenticationResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AuthenticationResponseToJson(
        AuthenticationResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user
    };
