import 'package:json_annotation/json_annotation.dart';
part 'system_status_payload.g.dart';

@JsonSerializable()
class SystemStatusPayload {
  String status;

  SystemStatusPayload({this.status});

  factory SystemStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusPayloadToJson(this);
}
