import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/shelf.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_task.g.dart';

@JsonSerializable()
class DefaultTask {
  int taskId;
  String type;
  Product product;
  int quantity;
  String state;
  Shelf shelf;

  DefaultTask({this.type, this.product, this.quantity, this.state, this.shelf});

  factory DefaultTask.fromJson(Map<String, dynamic> json) =>
      _$DefaultTaskFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultTaskToJson(this);
}
