// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_gap_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteGapTaskRequest _$CompleteGapTaskRequestFromJson(
    Map<String, dynamic> json) {
  return CompleteGapTaskRequest(
      taskId: json['taskId'] as int,
      ean: json['ean'] as String,
      quantity: json['quantity'] as int,
      shelfExternalId: json['shelfExternalId'] as String);
}

Map<String, dynamic> _$CompleteGapTaskRequestToJson(
        CompleteGapTaskRequest instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'ean': instance.ean,
      'shelfExternalId': instance.shelfExternalId,
      'quantity': instance.quantity
    };
