import 'package:customer/network/generic/exceptions/AppExceptions.dart';
import 'package:customer/network/generic/services_base_api.dart';
import 'package:customer/network/model/responses/receipts_response.dart';
import 'package:customer/network/model/sensei_error.dart';

abstract class ReceiptsDataSource {
  Future<ReceiptsResponse> getReceipts();
}

class ReceiptsRemoteDataSource implements ReceiptsDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  Future<ReceiptsResponse> getReceipts() async {
    try {
      var response = await baseApi.get("customers/own/sales");
      return ReceiptsResponse.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
