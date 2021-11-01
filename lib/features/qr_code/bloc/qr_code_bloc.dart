import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staffapp/features/qr_code/data/qr_code_repository.dart';
import 'package:staffapp/network/model/gate_token.dart';
import 'package:staffapp/network/model/sensei_error.dart';

part 'qr_code_event.dart';
part 'qr_code_state.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  final QRCodeRepository repository;
  Timer timer;

  QrCodeBloc({this.repository}) : super(QrCodeInitial());

  @override
  Stream<QrCodeState> mapEventToState(
    QrCodeEvent event,
  ) async* {
    yield QrCodeLoading();
    if (event is GetQRCode) {
      try {
        GateToken gateToken = await _getTokenAndStartTimer(event);
        yield QrCodeLoaded(gateToken);
      } catch (e) {
        print("Error: $e");
        yield QrCodeError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is ResetQRCode) {
      cancelTimer();
      yield QrCodeInitial();
    }
  }

  Future<GateToken> _getTokenAndStartTimer(GetQRCode event) async {
    GateToken gateToken = await repository.getStaffGateToken();

    DateTime _expiryTime =
        DateTime.parse(gateToken.expiry)?.subtract(Duration(seconds: 30));
    Duration _ttexpire = _expiryTime.difference(DateTime.now());

    print(_expiryTime);
    print(_ttexpire);

    cancelTimer();
    startTimer(_ttexpire, event);
    return gateToken;
  }

  startTimer(Duration duration, GetQRCode event) {
    timer = Timer.periodic(duration, (timer) {
      BlocProvider.of<QrCodeBloc>(event.context).add(GetQRCode(event.context));
    });
  }

  cancelTimer() {
    if (timer != null) timer.cancel();
  }
}
