part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class StartWorkSession extends DashboardEvent {
  StartWorkSession();

  @override
  List<Object> get props => [];
}

class StopWorkSession extends DashboardEvent {
  StopWorkSession();

  @override
  List<Object> get props => [];
}
