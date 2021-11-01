// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductIdResponse _$ProductIdResponseFromJson(Map<String, dynamic> json) {
  return ProductIdResponse(
      id: json['id'] as int,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ProductIdResponseToJson(ProductIdResponse instance) =>
    <String, dynamic>{'id': instance.id, 'product': instance.product};
