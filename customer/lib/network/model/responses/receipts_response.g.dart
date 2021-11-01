// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptsResponse _$ReceiptsResponseFromJson(Map<String, dynamic> json) {
  return ReceiptsResponse(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Receipt.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ReceiptsResponseToJson(ReceiptsResponse instance) =>
    <String, dynamic>{'content': instance.content};
