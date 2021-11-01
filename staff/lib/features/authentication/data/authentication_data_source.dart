import 'dart:convert';
import 'package:staffapp/network/generic/auth_base_api.dart';
import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import 'package:staffapp/network/model/requests/authentication.dart';
import 'package:staffapp/network/model/responses/authentication_response.dart';
import 'package:staffapp/network/model/sensei_error.dart';

abstract class AuthenticationDataSource {
  Future<AuthenticationResponse> performAuthentication(
      AuthenticationRequest authenticationRequest);
}

class AuthenticationRemoteDataSource implements AuthenticationDataSource {
  AuthBaseApi baseApi = AuthBaseApi();

  @override
  Future<AuthenticationResponse> performAuthentication(
      AuthenticationRequest authenticationRequest) async {
    try {
      var body = json.encode(authenticationRequest);
      var response = await baseApi.post("login", body);
      return AuthenticationResponse.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
