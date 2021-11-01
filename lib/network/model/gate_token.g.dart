// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gate_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GateToken _$GateTokenFromJson(Map<String, dynamic> json) {
  return GateToken(id: json['id'] as int, token: json['token'] as String)
    ..expiry = json['expiry'] as String;
}

Map<String, dynamic> _$GateTokenToJson(GateToken instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'expiry': instance.expiry
    };
