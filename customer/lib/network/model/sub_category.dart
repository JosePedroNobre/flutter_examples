import 'package:customer/network/model/category.dart';
import 'package:customer/network/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_category.g.dart';

@JsonSerializable()
class SubCategory {
  String name;
  String image;
  List<Product> products;
  Category category;

  SubCategory({
    this.name,
    this.image,
    this.products,
    this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}
