import 'package:json_annotation/json_annotation.dart';

part 'withdrawn_task_input.g.dart';

@JsonSerializable()
class WithdrawnTaskInput {
  String ean;
  String shelfExternalId;
  int quantity;

  WithdrawnTaskInput({this.ean, this.quantity, this.shelfExternalId});

  factory WithdrawnTaskInput.fromJson(Map<String, dynamic> json) =>
      _$WithdrawnTaskInputFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawnTaskInputToJson(this);
}
