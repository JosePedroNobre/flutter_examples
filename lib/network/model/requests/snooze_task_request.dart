import 'package:json_annotation/json_annotation.dart';

part 'snooze_task_request.g.dart';

@JsonSerializable()
class SnoozeTaskRequest {
  int taskId;

  SnoozeTaskRequest({this.taskId});

  factory SnoozeTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$SnoozeTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SnoozeTaskRequestToJson(this);
}
