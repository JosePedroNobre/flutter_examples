import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import 'package:staffapp/network/generic/services_base_api.dart';
import 'package:staffapp/network/model/gate_token.dart';
import 'package:staffapp/network/model/sensei_error.dart';

abstract class QRCodeDataSource {
  Future<GateToken> getStaffGateToken();
}

class QRCodeRemoteDataSource implements QRCodeDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  Future<GateToken> getStaffGateToken() async {
    try {
      var response = await baseApi
          .post("gate-token/staff", null, {"select": "token,expiry"});
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
