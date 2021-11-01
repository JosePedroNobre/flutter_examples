import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import '../utility/dio_logger.dart';
import 'dio_connectivity_request_retrier.dart';
import 'interceptors/no_internet_interceptor.dart';

class AuthBaseApi {
  static String _baseURL = "";
  static const String TAG = 'AuthBaseApi';

  static setBaseURL(String url) {
    _baseURL = url;
  }

  Dio dio = Dio();

  AuthBaseApi() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          options.headers.addAll({
            "Accept": "application/json",
            "content-type": "application/json"
          });
          DioLogger.onSend(TAG, options);
          return options;
        },
        onResponse: (Response response) async {
          DioLogger.onSuccess(TAG, response);
          return response;
        },
        onError: (e) async {
          throw e;
        },
      ),
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

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    try {
      var response = await dio.post(url, data: body);
      responseJson = response.data;
    } on TimeoutException catch (_) {
      throw GenericException(dioError: DioError());
    } on SocketException {
      print("No Internet");
      throw GenericException(dioError: DioError());
    }
    return responseJson;
  }
}
