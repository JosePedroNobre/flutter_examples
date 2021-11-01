import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:customer/env/main_common.dart';
import 'package:customer/features/authentication/presentation/landing_screen.dart';
import 'package:customer/network/generic/auth_base_api.dart';
import 'package:customer/network/generic/exceptions/AppExceptions.dart';
import 'package:customer/network/model/requests/refresh_token_request.dart';
import 'package:customer/network/model/responses/authentication_response.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:customer/network/network_defaults.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../utility/dio_logger.dart';
import 'dio_connectivity_request_retrier.dart';
import 'interceptors/no_internet_interceptor.dart';

class ServicesBaseApi {
  static String _baseURL = "";
  static const String TAG = 'ServicesBaseApi';

  static setBaseURL(String url) {
    _baseURL = url;
  }

  AuthBaseApi _authBaseApi = AuthBaseApi();
  Dio dio = Dio();

  ServicesBaseApi() {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        String accessToken = await NetworkDefaults.getToken();
        bool hasExpired = JwtDecoder.isExpired(accessToken);

        // Check whether the access token has expired,
        // if so, refresh it before the request.
        if (hasExpired) {
          dio.interceptors.requestLock.lock();
          dio.interceptors.responseLock.lock();
          String _savedRefreshToken = await NetworkDefaults.getRefreshToken();
          AuthenticationResponse authResponse =
              await refreshToken(_savedRefreshToken);
          NetworkDefaults.setToken(authResponse.accessToken);
          accessToken = authResponse.accessToken;
          dio.interceptors.requestLock.unlock();
          dio.interceptors.responseLock.unlock();
        }

        String authToken =
            "Bearer ${accessToken.replaceAll(new RegExp('"'), '')}";
        options.headers.addAll({
          "Authorization": authToken,
          "Accept": "application/json",
          "content-type": "application/json"
        });
        DioLogger.onSend(TAG, options);
        print(options);
        return options;
      }, onResponse: (Response response) async {
        DioLogger.onSuccess(TAG, response);
        return response;
      }, onError: (DioError error) async {
        if (error.response?.statusCode == 401) {
          _logout();
        } else {
          return error;
        }
      }),
    );

    // Interceptor to retry request when when connectivity changes.
    dio.interceptors.add(
      NoInternetInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    // http options
    dio.options.baseUrl = _baseURL;
    dio.options.connectTimeout = 100000; //10s
    dio.options.receiveTimeout = 100000;
  }

  Future<dynamic> post(
      String url, dynamic body, Map<String, dynamic> queryParams) async {
    var responseJson;
    try {
      var response =
          await dio.post(url, data: body, queryParameters: queryParams);
      responseJson = response.data;
    } on TimeoutException catch (_) {
      throw GenericException(dioError: DioError());
    } on SocketException {
      print("No Internet");
      throw GenericException(dioError: DioError());
    }
    return responseJson;
  }

  Future<dynamic> get(String url,
      {Map<String, dynamic> queryParameters}) async {
    var responseJson;
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      responseJson = response.data;
    } on TimeoutException catch (_) {
      print("Timeout");
    } on SocketException {
      print("No Internet");
      throw GenericException(dioError: DioError());
    }
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await dio.put(url, data: body);
      responseJson = response.data;
    } on TimeoutException catch (_) {
      print("Timeout");
    } on SocketException {
      print('No net');
      throw GenericException(dioError: DioError());
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var apiResponse;
    try {
      final response = await dio.delete(url);
      apiResponse = response.data;
    } on TimeoutException catch (_) {
      print("Timeout");
    } on SocketException {
      print('No net');
      throw GenericException(dioError: DioError());
    }
    return apiResponse;
  }

  Future<AuthenticationResponse> refreshToken(String token) async {
    try {
      RefreshTokenRequest _refreshToken = RefreshTokenRequest(
          refreshToken: token.replaceAll(new RegExp('"'), ''));
      var response = await _authBaseApi.post("refresh", _refreshToken);
      return AuthenticationResponse.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  _logout() async {
    await NetworkDefaults.removeAll();
    navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LandingScreen()),
        (Route<dynamic> route) => route.isFirst);
  }
}
