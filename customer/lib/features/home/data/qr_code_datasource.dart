import 'package:customer/network/generic/exceptions/AppExceptions.dart';
import 'package:customer/network/generic/services_base_api.dart';
import 'package:customer/network/model/gate_token.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:customer/network/model/store.dart';

abstract class QRCodeDataSource {
  Future<GateToken> getGateToken();
  Future<List<Store>> getStores();
}

class QRCodeRemoteDataSource implements QRCodeDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  Future<GateToken> getGateToken() async {
    try {
      var response =
          await baseApi.post("gate-token", null, {"select": "token,expiry"});
      return GateToken.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  Future<List<Store>> getStores() async {
    try {
      var response = await baseApi.get(
        "stores",
        queryParameters: {"select": "id,name,address{*}"},
      );
      return List<Store>.from(response.map((i) => Store.fromJson(i)));
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
