import 'package:json_annotation/json_annotation.dart';
part 'shelf.g.dart';

@JsonSerializable()
class Shelf {
  String originExternalId;
  String externalId;

  Shelf({this.originExternalId, this.externalId});

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);

  Map<String, dynamic> toJson() => _$ShelfToJson(this);
}
