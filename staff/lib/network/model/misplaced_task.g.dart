// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misplaced_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisplacedTask _$MisplacedTaskFromJson(Map<String, dynamic> json) {
  return MisplacedTask(
      type: json['type'] as String,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      state: json['state'] as String,
      shelf: json['shelf'] == null
          ? null
          : Shelf.fromJson(json['shelf'] as Map<String, dynamic>),
      destinationShelf: (json['destinationShelf'] as List)
          ?.map((e) =>
              e == null ? null : Shelf.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..taskId = json['taskId'] as int;
}

Map<String, dynamic> _$MisplacedTaskToJson(MisplacedTask instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'type': instance.type,
      'product': instance.product,
      'quantity': instance.quantity,
      'state': instance.state,
      'shelf': instance.shelf,
      'destinationShelf': instance.destinationShelf
    };
