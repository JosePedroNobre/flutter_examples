import 'package:customer/network/model/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  String name;
  String description;
  String image;
  String price;
  bool isRecommended;
  bool isOutOfStock;
  Category category;

  Product({
    this.name,
    this.description,
    this.image,
    this.price,
    this.isRecommended,
    this.isOutOfStock = false,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
