part of 'authentication_bloc.dart';

abstract class AuthenticationBlocState extends Equatable {
  const AuthenticationBlocState();

  @override
  List<Object> get props => [];
}

// perform authentication events
class AuthenticationInitial extends AuthenticationBlocState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationBlocState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoaded extends AuthenticationBlocState {
  final AuthenticationResponse authenticationResponse;

  AuthenticationLoaded({this.authenticationResponse});

  @override
  List<Object> get props => [authenticationResponse];
}

// get available emails events
class GetAvailableEmailsLoading extends AuthenticationBlocState {
  @override
  List<Object> get props => [];
}

class GetAvailableEmailsLoaded extends AuthenticationBlocState {
  final List<String> emails;

  GetAvailableEmailsLoaded({this.emails});

  @override
  List<Object> get props => [emails];
}

// common events
class Error extends AuthenticationBlocState {
  final SenseiError senseiError;
  Error({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
