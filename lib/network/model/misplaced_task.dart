import 'package:staffapp/network/model/product.dart' as P;
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/shelf.dart';
import 'package:json_annotation/json_annotation.dart';

part 'misplaced_task.g.dart';

@JsonSerializable()
class MisplacedTask {
  int taskId;
  String type;
  P.Product product;
  int quantity;
  String state;
  Shelf shelf;
  List<Shelf> destinationShelf;

  MisplacedTask(
      {this.type,
      this.product,
      this.quantity,
      this.state,
      this.shelf,
      this.destinationShelf});

  factory MisplacedTask.fromJson(Map<String, dynamic> json) =>
      _$MisplacedTaskFromJson(json);

  Map<String, dynamic> toJson() => _$MisplacedTaskToJson(this);
}
