// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
      name: json['name'] as String,
      image: json['image'] as String,
      products: (json['products'] as List)
          ?.map((e) =>
              e == null ? null : Product.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      category: json['category']);
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'products': instance.products,
      'category': instance.category
    };
