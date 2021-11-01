// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawn_task_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawnTaskInput _$WithdrawnTaskInputFromJson(Map<String, dynamic> json) {
  return WithdrawnTaskInput(
      ean: json['ean'] as String,
      quantity: json['quantity'] as int,
      shelfExternalId: json['shelfExternalId'] as String);
}

Map<String, dynamic> _$WithdrawnTaskInputToJson(WithdrawnTaskInput instance) =>
    <String, dynamic>{
      'ean': instance.ean,
      'shelfExternalId': instance.shelfExternalId,
      'quantity': instance.quantity
    };
