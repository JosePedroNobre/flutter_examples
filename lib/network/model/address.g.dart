// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      id: json['id'] as int,
      address: json['address'] as String,
      postalCode: json['postalCode'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      countryISO2: json['countryISO2'] as String);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'region': instance.region,
      'countryISO2': instance.countryISO2
    };
