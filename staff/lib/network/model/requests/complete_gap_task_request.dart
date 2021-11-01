import 'package:json_annotation/json_annotation.dart';

part 'complete_gap_task_request.g.dart';

@JsonSerializable()
class CompleteGapTaskRequest {
  int taskId;
  String ean;
  String shelfExternalId;
  int quantity;

  CompleteGapTaskRequest(
      {this.taskId, this.ean, this.quantity, this.shelfExternalId});

  factory CompleteGapTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteGapTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteGapTaskRequestToJson(this);
}
