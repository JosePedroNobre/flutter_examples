import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../dio_connectivity_request_retrier.dart';

final connectivitySubject = PublishSubject<bool>();

class NoInternetInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  NoInternetInterceptor({
    @required this.requestRetrier,
  });

  @override
  Future onError(DioError err) async {
    if (_shouldRetry(err)) {
      try {
        return requestRetrier.scheduleRequestRetry(err.request);
      } catch (e) {
        // Let any new error from the retrier pass through
        return e;
      }
    }
    // Let the error pass through if it's not the error we're looking for
    return err;
  }

  bool _shouldRetry(DioError err) {
    bool _isConnected = err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
    connectivitySubject.add(_isConnected);
    return _isConnected;
  }
}
