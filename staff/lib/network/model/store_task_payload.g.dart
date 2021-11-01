// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_task_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreTaskPayload _$StoreTaskPayloadFromJson(Map<String, dynamic> json) {
  return StoreTaskPayload(
      taskResponse: json['taskResponse'] == null
          ? null
          : TaskResponse.fromJson(
              json['taskResponse'] as Map<String, dynamic>));
}

Map<String, dynamic> _$StoreTaskPayloadToJson(StoreTaskPayload instance) =>
    <String, dynamic>{'taskResponse': instance.taskResponse};
