import 'package:staffapp/network/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_id_response.g.dart';

@JsonSerializable()
class ProductIdResponse {
  int id;
  Product product;

  ProductIdResponse({
    this.id,
    this.product,
  });

  factory ProductIdResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductIdResponseToJson(this);
}
