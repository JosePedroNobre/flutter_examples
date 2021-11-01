import 'package:json_annotation/json_annotation.dart';

part 'external_gate_token_request.g.dart';

@JsonSerializable()
class ExternalGateTokenRequest {
  String externalRoleDescription;

  ExternalGateTokenRequest({this.externalRoleDescription});

  factory ExternalGateTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$ExternalGateTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalGateTokenRequestToJson(this);
}
