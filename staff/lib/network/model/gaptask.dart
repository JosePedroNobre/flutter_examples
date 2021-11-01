import 'package:staffapp/network/model/product.dart' as P;
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/shelf.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gaptask.g.dart';

@JsonSerializable()
class GapTask {
  int taskId;
  String type;
  P.Product product;
  int quantity;
  String state;
  Shelf shelf;

  GapTask({this.type, this.product, this.quantity, this.state, this.shelf});

  factory GapTask.fromJson(Map<String, dynamic> json) =>
      _$GapTaskFromJson(json);

  Map<String, dynamic> toJson() => _$GapTaskToJson(this);
}
