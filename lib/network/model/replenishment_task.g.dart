// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replenishment_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplenishmentTask _$ReplenishmentTaskFromJson(Map<String, dynamic> json) {
  return ReplenishmentTask(
      type: json['type'] as String,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      state: json['state'] as String,
      shelf: json['shelf'] == null
          ? null
          : Shelf.fromJson(json['shelf'] as Map<String, dynamic>))
    ..taskId = json['taskId'] as int;
}

Map<String, dynamic> _$ReplenishmentTaskToJson(ReplenishmentTask instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'type': instance.type,
      'product': instance.product,
      'quantity': instance.quantity,
      'state': instance.state,
      'shelf': instance.shelf
    };
