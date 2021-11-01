part of 'authentication_bloc.dart';

abstract class AuthenticationBlocEvent extends Equatable {
  const AuthenticationBlocEvent();

  @override
  List<Object> get props => [];
}

class PerformAuthentication extends AuthenticationBlocEvent {
  final AuthenticationRequest authentication;

  PerformAuthentication({this.authentication});

  @override
  List<Object> get props => [authentication];
}

class GetAvailableEmails extends AuthenticationBlocEvent {
  GetAvailableEmails();

  @override
  List<Object> get props => [];
}
