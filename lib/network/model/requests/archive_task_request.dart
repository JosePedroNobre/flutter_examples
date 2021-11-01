import 'package:json_annotation/json_annotation.dart';

part 'archive_task_request.g.dart';

@JsonSerializable()
class ArchiveTaskRequest {
  int taskId;

  ArchiveTaskRequest({this.taskId});

  factory ArchiveTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$ArchiveTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveTaskRequestToJson(this);
}
