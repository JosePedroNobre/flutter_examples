part of 'authentication_bloc.dart';

abstract class AuthenticationBlocState extends Equatable {
  const AuthenticationBlocState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationBlocState {}

// perform authentication events
class AuthenticationLoading extends AuthenticationBlocState {}

class AuthenticationLoaded extends AuthenticationBlocState {
  final AuthenticationResponse authenticationResponse;

  AuthenticationLoaded({this.authenticationResponse});

  @override
  List<Object> get props => [authenticationResponse];
}

class AuthenticationError extends AuthenticationBlocState {
  final SenseiError senseiError;
  AuthenticationError({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
