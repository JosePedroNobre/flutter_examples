import 'package:json_annotation/json_annotation.dart';

part 'store_occupancy_payload.g.dart';

@JsonSerializable()
class StoreOccupancyPayload {
  int occupation;
  int maximumOccupancy;
  int externalAccessesRegistered;

  StoreOccupancyPayload(
      {this.occupation,
      this.maximumOccupancy,
      this.externalAccessesRegistered});

  factory StoreOccupancyPayload.fromJson(Map<String, dynamic> json) =>
      _$StoreOccupancyPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$StoreOccupancyPayloadToJson(this);
}
