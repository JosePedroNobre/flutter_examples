// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_occupancy_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreOccupancyPayload _$StoreOccupancyPayloadFromJson(
    Map<String, dynamic> json) {
  return StoreOccupancyPayload(
      occupation: json['occupation'] as int,
      maximumOccupancy: json['maximumOccupancy'] as int,
      externalAccessesRegistered: json['externalAccessesRegistered'] as int);
}

Map<String, dynamic> _$StoreOccupancyPayloadToJson(
        StoreOccupancyPayload instance) =>
    <String, dynamic>{
      'occupation': instance.occupation,
      'maximumOccupancy': instance.maximumOccupancy,
      'externalAccessesRegistered': instance.externalAccessesRegistered
    };
