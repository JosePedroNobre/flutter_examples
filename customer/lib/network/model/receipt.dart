import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';

@JsonSerializable()
class Receipt {
  int id;
  double total;
  String timestamp;
  @JsonKey(ignore: true)
  bool isOpen;

  Receipt({this.id, this.timestamp, this.total, this.isOpen = false});

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}
