import 'dart:convert';

import 'package:customer/network/generic/auth_base_api.dart';
import 'package:customer/network/generic/exceptions/AppExceptions.dart';
import 'package:customer/network/model/requests/authentication.dart';
import 'package:customer/network/model/responses/authentication_response.dart';
import 'package:customer/network/model/sensei_error.dart';

abstract class AuthenticationDataSource {
  Future<AuthenticationResponse> performAuthentication(
      AuthenticationRequest authenticationRequest);

  Future<List<String>> getAvailableEmails();
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

  @override
  Future<List<String>> getAvailableEmails() async {
    try {
      var response =
          await baseApi.get("demo-available-users?domainName=pickandgo");
      return List<String>.from(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
