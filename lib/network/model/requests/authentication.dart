import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class AuthenticationRequest {
  String username;
  String password;
  String domainName;

  AuthenticationRequest({this.username, this.password, this.domainName});

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationRequestToJson(this);
}
