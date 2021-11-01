import 'package:staffapp/features/authentication/data/authentication_data_source.dart';
import 'package:staffapp/network/model/requests/authentication.dart';
import 'package:staffapp/network/model/responses/authentication_response.dart';

class AuthenticationRepository {
  final AuthenticationDataSource authenticationDataSource;

  AuthenticationRepository({this.authenticationDataSource});

  Future<AuthenticationResponse> performAuthentication(
          AuthenticationRequest authenticationRequest) =>
      authenticationDataSource.performAuthentication(authenticationRequest);
}
