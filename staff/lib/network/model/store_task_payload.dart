import 'package:json_annotation/json_annotation.dart';
import 'package:staffapp/network/model/task_response.dart';

part 'store_task_payload.g.dart';

@JsonSerializable()
class StoreTaskPayload {
  TaskResponse taskResponse;

  StoreTaskPayload({this.taskResponse});

  factory StoreTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$StoreTaskPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$StoreTaskPayloadToJson(this);
}
