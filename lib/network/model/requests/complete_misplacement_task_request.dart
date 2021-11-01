import 'package:json_annotation/json_annotation.dart';

part 'complete_misplacement_task_request.g.dart';

@JsonSerializable()
class CompleteMisplacementTaskRequest {
  int taskId;
  String ean;
  String originShelfExternalId;
  String destinationShelfExternalId;
  int quantity;

  CompleteMisplacementTaskRequest(
      {this.taskId,
      this.ean,
      this.quantity,
      this.originShelfExternalId,
      this.destinationShelfExternalId});

  factory CompleteMisplacementTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteMisplacementTaskRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CompleteMisplacementTaskRequestToJson(this);
}
