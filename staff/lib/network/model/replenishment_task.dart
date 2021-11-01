import 'package:staffapp/network/model/product.dart' as P;
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/shelf.dart';
import 'package:json_annotation/json_annotation.dart';

part 'replenishment_task.g.dart';

@JsonSerializable()
class ReplenishmentTask {
  int taskId;
  String type;
  P.Product product;
  int quantity;
  String state;
  Shelf shelf;

  ReplenishmentTask(
      {this.type, this.product, this.quantity, this.state, this.shelf});

  factory ReplenishmentTask.fromJson(Map<String, dynamic> json) =>
      _$ReplenishmentTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ReplenishmentTaskToJson(this);
}
