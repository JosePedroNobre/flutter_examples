import 'package:dio/dio.dart';

class AppException extends DioError {
  final String _message;

  AppException([this._message]);

  @override
  String toString() {
    return "$_message";
  }
}

class GenericException extends AppException {
  DioError dioError;
  GenericException({this.dioError});
}
