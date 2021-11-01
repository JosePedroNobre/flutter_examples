import 'package:customer/network/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  String accessToken;
  String refreshToken;
  User user;

  AuthenticationResponse({this.accessToken, this.refreshToken, this.user});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
