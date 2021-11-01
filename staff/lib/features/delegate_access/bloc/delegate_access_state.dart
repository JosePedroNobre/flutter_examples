part of 'delegate_access_bloc.dart';

abstract class DelegateAccessState extends Equatable {
  const DelegateAccessState();

  @override
  List<Object> get props => [];
}

class DelegateAccessInitial extends DelegateAccessState {}

class DelegateAccessLoaded extends DelegateAccessState {
  final GateToken gateToken;

  DelegateAccessLoaded(this.gateToken);

  @override
  List<Object> get props => [];
}

class DelegateAccessLoading extends DelegateAccessState {}

class DelegateAccessError extends DelegateAccessState {
  final SenseiError senseiError;

  DelegateAccessError({this.senseiError});

  @override
  List<Object> get props => [senseiError];
}
