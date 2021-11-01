import 'package:json_annotation/json_annotation.dart';

part 'unsaleable_task_input.g.dart';

@JsonSerializable()
class UnsaleableTaskInput {
  String ean;
  String shelfExternalId;
  int quantity;

  UnsaleableTaskInput({this.ean, this.quantity, this.shelfExternalId});

  factory UnsaleableTaskInput.fromJson(Map<String, dynamic> json) =>
      _$UnsaleableTaskInputFromJson(json);

  Map<String, dynamic> toJson() => _$UnsaleableTaskInputToJson(this);
}
