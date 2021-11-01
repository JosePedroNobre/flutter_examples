import 'package:customer/network/model/receipt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipts_response.g.dart';

@JsonSerializable()
class ReceiptsResponse {
  List<Receipt> content;

  ReceiptsResponse({this.content});

  factory ReceiptsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiptsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptsResponseToJson(this);
}
