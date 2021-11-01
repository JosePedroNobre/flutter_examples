// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_replenishment_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteReplenishmentTaskRequest _$CompleteReplenishmentTaskRequestFromJson(
    Map<String, dynamic> json) {
  return CompleteReplenishmentTaskRequest(
      taskId: json['taskId'] as int,
      ean: json['ean'] as String,
      quantity: json['quantity'] as int,
      shelfExternalId: json['shelfExternalId'] as String);
}

Map<String, dynamic> _$CompleteReplenishmentTaskRequestToJson(
        CompleteReplenishmentTaskRequest instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'ean': instance.ean,
      'shelfExternalId': instance.shelfExternalId,
      'quantity': instance.quantity
    };
