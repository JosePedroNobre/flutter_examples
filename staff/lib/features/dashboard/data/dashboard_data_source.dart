import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import 'package:staffapp/network/generic/services_base_api.dart';
import 'package:staffapp/network/model/sensei_error.dart';

abstract class DashboardDataSource {
  startWorkSession();
  stopWorkSession();
}

class DashboardRemoteDataSource implements DashboardDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  startWorkSession() async {
    try {
      await baseApi.post("staffapp/worksession/start", null, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  stopWorkSession() async {
    try {
      await baseApi.post("staffapp/worksession/stop", null, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
