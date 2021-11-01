import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staffapp/features/delegate_access/data/delegate_access_repository.dart';
import 'package:staffapp/network/model/gate_token.dart';
import 'package:staffapp/network/model/sensei_error.dart';

part 'delegate_access_event.dart';
part 'delegate_access_state.dart';

class DelegateAccessBloc
    extends Bloc<DelegateAccessEvent, DelegateAccessState> {
  final DelegateAccessRepository repository;
  Timer timer;

  DelegateAccessBloc({this.repository}) : super(DelegateAccessInitial());

  @override
  Stream<DelegateAccessState> mapEventToState(
    DelegateAccessEvent event,
  ) async* {
    if (event is GetDelegateAccess) {
      yield DelegateAccessLoading();
      try {
        GateToken _gateToken = await _getTokenAndStartTimer(event);
        yield DelegateAccessLoaded(_gateToken);
      } catch (e) {
        print("Error: $e");
        yield DelegateAccessError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is ResetDelegateAccess) {
      cancelTimer();
      yield DelegateAccessInitial();
    }
  }

  Future<GateToken> _getTokenAndStartTimer(GetDelegateAccess event) async {
    GateToken gateToken =
        await repository.getExternalGateToken(event.accessType);

    DateTime _expiryTime =
        DateTime.parse(gateToken.expiry)?.subtract(Duration(seconds: 30));
    Duration _ttexpire = _expiryTime.difference(DateTime.now());

    print(_expiryTime);
    print(_ttexpire);

    cancelTimer();
    startTimer(_ttexpire, event);
    return gateToken;
  }

  startTimer(Duration duration, GetDelegateAccess event) {
    timer = Timer.periodic(duration, (timer) {
      BlocProvider.of<DelegateAccessBloc>(event.context)
          .add(GetDelegateAccess(event.accessType, event.context));
    });
  }

  cancelTimer() {
    if (timer != null) timer.cancel();
  }
}
