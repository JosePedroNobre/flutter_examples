import 'package:customer/features/authentication/data/authentication_data_source.dart';
import 'package:customer/network/model/requests/authentication.dart';
import 'package:customer/network/model/responses/authentication_response.dart';

class AuthenticationRepository {
  final AuthenticationDataSource authenticationDataSource;

  AuthenticationRepository({this.authenticationDataSource});

  Future<AuthenticationResponse> performAuthentication(
          AuthenticationRequest authenticationRequest) =>
      authenticationDataSource.performAuthentication(authenticationRequest);

  Future<List<String>> getAvailableEmails() =>
      authenticationDataSource.getAvailableEmails();
}
