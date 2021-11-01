import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:staffapp/features/dashboard/data/dashboard_repository.dart';
import 'package:staffapp/network/model/sensei_error.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({this.repository}) : super(PresentationInitial());

  final DashboardRepository repository;

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is StartWorkSession) {
      try {
        await repository.startWorkSession();
      } catch (e) {
        yield WorkSessionError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is StopWorkSession) {
      try {
        await repository.stopWorkSession();
      } catch (e) {
        yield WorkSessionError(senseiError: e is SenseiError ? e : null);
      }
    }
  }
}
