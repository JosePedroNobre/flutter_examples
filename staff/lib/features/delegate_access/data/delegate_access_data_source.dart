import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import 'package:staffapp/network/generic/services_base_api.dart';
import 'package:staffapp/network/model/gate_token.dart';
import 'package:staffapp/network/model/requests/external_gate_token_request.dart';
import 'package:staffapp/network/model/sensei_error.dart';

abstract class DelegateAccessDataSource {
  Future<GateToken> getExternalGateToken(String accessType);
}

class DelegateAccessRemoteDataSource implements DelegateAccessDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  Future<GateToken> getExternalGateToken(String accessType) async {
    try {
      ExternalGateTokenRequest body =
          ExternalGateTokenRequest(externalRoleDescription: accessType);

      var response = await baseApi
          .post("gate-token/external", body, {"select": "token,expiry"});
      return GateToken.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
