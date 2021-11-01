import 'package:json_annotation/json_annotation.dart';
part 'work_session_status_payload.g.dart';

@JsonSerializable()
class WorkSessionStatusPayload {
  String myWorkSessionStatus;

  WorkSessionStatusPayload({this.myWorkSessionStatus});

  factory WorkSessionStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$WorkSessionStatusPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$WorkSessionStatusPayloadToJson(this);
}
