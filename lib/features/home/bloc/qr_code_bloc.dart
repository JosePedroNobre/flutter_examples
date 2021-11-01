import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer/features/home/data/qr_code_repository.dart';
import 'package:customer/network/model/gate_token.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:customer/network/model/store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qr_code_event.dart';
part 'qr_code_state.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  final QRCodeRepository repository;
  static const SECONDS_BEFORE_EXPIRY = 10;
  Timer timer;

  QrCodeBloc(this.repository) : super(QrCodeScreenInitial());

  @override
  Stream<QrCodeState> mapEventToState(
    QrCodeEvent event,
  ) async* {
    if (event is GetStores) {
      yield StoresLoading();
      try {
        List<Store> stores = await repository.getStores();
        yield StoresLoaded(stores);
      } catch (e) {
        yield QrCodeScreenError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is GetQRCode) {
      yield QRCodeLoading();
      try {
        GateToken _gateToken = await _getTokenAndStartTimer(event);
        yield QRCodeLoaded(_gateToken);
      } catch (e) {
        yield QrCodeScreenError(senseiError: e is SenseiError ? e : null);
      }
    }
  }

  Future<GateToken> _getTokenAndStartTimer(GetQRCode event) async {
    GateToken gateToken = await repository.getGateToken();

    DateTime _expiryTime = DateTime.parse(gateToken.expiry)
        ?.subtract(Duration(seconds: SECONDS_BEFORE_EXPIRY));
    Duration _ttexpire = _expiryTime.difference(DateTime.now());

    print(_expiryTime);
    print(_ttexpire);

    cancelTimer();
    startTimer(_ttexpire, event);
    return gateToken;
  }

  startTimer(Duration duration, GetQRCode event) {
    timer = Timer.periodic(duration, (timer) {
      BlocProvider.of<QrCodeBloc>(event.context)
          .add(GetQRCode(context: event.context));
    });
  }

  cancelTimer() {
    if (timer != null) timer.cancel();
  }
}
