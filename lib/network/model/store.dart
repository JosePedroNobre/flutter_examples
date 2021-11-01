import 'package:customer/network/model/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  int id;
  String name;
  Address address;
  double lat;
  double long;

  Store({this.id, this.name, this.address, this.lat, this.long});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
