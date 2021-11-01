part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class PresentationInitial extends DashboardState {}

class WorkSessionError extends DashboardState {
  final SenseiError senseiError;
  WorkSessionError({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
