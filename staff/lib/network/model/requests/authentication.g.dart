// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationRequest _$AuthenticationRequestFromJson(
    Map<String, dynamic> json) {
  return AuthenticationRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      domainName: json['domainName'] as String);
}

Map<String, dynamic> _$AuthenticationRequestToJson(
        AuthenticationRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'domainName': instance.domainName
    };
