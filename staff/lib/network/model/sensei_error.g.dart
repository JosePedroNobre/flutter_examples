// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensei_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SenseiError _$SenseiErrorFromJson(Map<String, dynamic> json) {
  return SenseiError(json['message'] as String, json['errorCode'] as String,
      json['status'] as int);
}

Map<String, dynamic> _$SenseiErrorToJson(SenseiError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errorCode': instance.errorCode,
      'status': instance.status
    };
