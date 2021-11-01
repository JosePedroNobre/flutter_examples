import 'package:json_annotation/json_annotation.dart';

part 'gate_token.g.dart';

@JsonSerializable()
class GateToken {
  int id;
  String token;
  String expiry;

  GateToken({this.id, this.token});

  factory GateToken.fromJson(Map<String, dynamic> json) =>
      _$GateTokenFromJson(json);

  Map<String, dynamic> toJson() => _$GateTokenToJson(this);
}
