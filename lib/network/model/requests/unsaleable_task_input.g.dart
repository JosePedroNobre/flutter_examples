// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsaleable_task_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnsaleableTaskInput _$UnsaleableTaskInputFromJson(Map<String, dynamic> json) {
  return UnsaleableTaskInput(
      ean: json['ean'] as String,
      quantity: json['quantity'] as int,
      shelfExternalId: json['shelfExternalId'] as String);
}

Map<String, dynamic> _$UnsaleableTaskInputToJson(
        UnsaleableTaskInput instance) =>
    <String, dynamic>{
      'ean': instance.ean,
      'shelfExternalId': instance.shelfExternalId,
      'quantity': instance.quantity
    };
