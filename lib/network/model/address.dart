import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  int id;
  String address;
  String postalCode;
  String city;
  String region;
  String countryISO2;

  Address(
      {this.id,
      this.address,
      this.postalCode,
      this.city,
      this.region,
      this.countryISO2});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
