import 'package:staffapp/network/model/domain.dart';
import 'package:staffapp/network/model/staff.dart';
import 'package:staffapp/network/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  String accessToken;
  String refreshToken;
  User user;
  Domain domain;
  Staff staff;

  AuthenticationResponse(
      {this.accessToken,
      this.domain,
      this.refreshToken,
      this.staff,
      this.user});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
