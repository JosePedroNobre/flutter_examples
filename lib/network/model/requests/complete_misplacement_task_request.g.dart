// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_misplacement_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteMisplacementTaskRequest _$CompleteMisplacementTaskRequestFromJson(
    Map<String, dynamic> json) {
  return CompleteMisplacementTaskRequest(
      taskId: json['taskId'] as int,
      ean: json['ean'] as String,
      quantity: json['quantity'] as int,
      originShelfExternalId: json['originShelfExternalId'] as String,
      destinationShelfExternalId: json['destinationShelfExternalId'] as String);
}

Map<String, dynamic> _$CompleteMisplacementTaskRequestToJson(
        CompleteMisplacementTaskRequest instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'ean': instance.ean,
      'originShelfExternalId': instance.originShelfExternalId,
      'destinationShelfExternalId': instance.destinationShelfExternalId,
      'quantity': instance.quantity
    };
