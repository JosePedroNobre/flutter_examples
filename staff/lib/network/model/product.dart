import 'package:staffapp/network/model/image.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  int id;
  String name;
  Image image;
  String ean;

  Product({this.id, this.name, this.image, this.ean});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
