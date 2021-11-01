import 'package:json_annotation/json_annotation.dart';

part 'complete_replenishment_task_request.g.dart';

@JsonSerializable()
class CompleteReplenishmentTaskRequest {
  int taskId;
  String ean;
  String shelfExternalId;
  int quantity;

  CompleteReplenishmentTaskRequest(
      {this.taskId, this.ean, this.quantity, this.shelfExternalId});

  factory CompleteReplenishmentTaskRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CompleteReplenishmentTaskRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CompleteReplenishmentTaskRequestToJson(this);
}
