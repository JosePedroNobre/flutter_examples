import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer/features/authentication/data/authentication_repository.dart';
import 'package:customer/network/model/requests/authentication.dart';
import 'package:customer/network/model/responses/authentication_response.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:customer/user_defaults.dart';
import 'package:equatable/equatable.dart';

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
        AuthenticationResponse response = await objectivesRepository
            .performAuthentication(event.authentication);
        UserDefaults.setName(response.user.name);
        UserDefaults.save(UserDefaultsKeys.USER.toString(), response.user);
        print(response);
        yield AuthenticationLoaded(authenticationResponse: response);
      } catch (e) {
        yield Error(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is GetAvailableEmails) {
      try {
        var response = await objectivesRepository.getAvailableEmails();
        yield GetAvailableEmailsLoaded(emails: response);
      } catch (e) {
        yield Error(senseiError: e is SenseiError ? e : null);
      }
    }
  }
}
