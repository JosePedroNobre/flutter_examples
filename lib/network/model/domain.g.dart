// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Domain _$DomainFromJson(Map<String, dynamic> json) {
  return Domain(
      id: json['id'] as int,
      dnsName: json['dnsName'] as String,
      name: json['name'] as String);
}

Map<String, dynamic> _$DomainToJson(Domain instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dnsName': instance.dnsName
    };
