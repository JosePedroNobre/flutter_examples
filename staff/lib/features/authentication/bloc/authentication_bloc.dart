import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:staffapp/features/authentication/data/authentication_repository.dart';
import 'package:staffapp/network/model/requests/authentication.dart';
import 'package:staffapp/network/model/responses/authentication_response.dart';
import 'package:staffapp/network/model/sensei_error.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationBlocEvent, AuthenticationBlocState> {
  AuthenticationBloc(this.objectivesRepository)
      : super(AuthenticationInitial());

  final AuthenticationRepository objectivesRepository;

  @override
  Stream<AuthenticationBlocState> mapEventToState(
    AuthenticationBlocEvent event,
  ) async* {
    if (event is PerformAuthentication) {
      yield AuthenticationLoading();
      try {
        var response = await objectivesRepository
            .performAuthentication(event.authentication);
        print(response);
        yield AuthenticationLoaded(authenticationResponse: response);
      } catch (e) {
        yield AuthenticationError(senseiError: e is SenseiError ? e : null);
      }
    }
  }
}
