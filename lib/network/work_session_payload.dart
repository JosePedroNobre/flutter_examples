import 'package:json_annotation/json_annotation.dart';
part 'work_session_payload.g.dart';

@JsonSerializable()
class WorkSessionPayload {
  int openWorkSessions;

  WorkSessionPayload({this.openWorkSessions});

  factory WorkSessionPayload.fromJson(Map<String, dynamic> json) =>
      _$WorkSessionPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$WorkSessionPayloadToJson(this);
}
