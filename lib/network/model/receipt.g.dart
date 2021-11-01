// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return Receipt(
      id: json['id'] as int,
      timestamp: json['timestamp'] as String,
      total: (json['total'] as num)?.toDouble());
}

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'id': instance.id,
      'total': instance.total,
      'timestamp': instance.timestamp
    };
