import 'package:dio/dio.dart';

class DioLogger {
  static void onSend(String tag, RequestOptions options) {
    print(
        '$tag - Request Path : [${options.method}] ${options.baseUrl}${options.path}${options.queryParameters}');
    print('$tag - Request Data : ${options.data.toString()}');
  }

  static void onSuccess(String tag, Response response) {
    print(
        '$tag - Response Path : [${response.request.method}] ${response.request.baseUrl}${response.request.path} Request Data : ${response.request.data.toString()}');
    print('$tag - Response statusCode : ${response.statusCode}');
    print('$tag - Response data : ${response.data.toString()}');
  }

  static void onError(String tag, DioError error) {
    if (null != error.response) {
      print(
          '$tag - Error Path : [${error.response.request.method}] ${error.response.request.baseUrl}${error.response.request.path} Request Data : ${error.response.request.data.toString()}');
      print('$tag - Error statusCode : ${error.response.statusCode}');
      print(
          '$tag - Error data : ${null != error.response.data ? error.response.data.toString() : ''}');
    }
    print('$tag - Error Message : ${error.message}');
  }
}
