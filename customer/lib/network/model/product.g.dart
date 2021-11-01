// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      isRecommended: json['isRecommended'] as bool,
      category: json['category']);
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'isRecommended': instance.isRecommended,
      'category': instance.category
    };
