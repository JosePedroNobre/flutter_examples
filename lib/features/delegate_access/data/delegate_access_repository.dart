import 'package:staffapp/features/delegate_access/data/delegate_access_data_source.dart';
import 'package:staffapp/network/model/gate_token.dart';

class DelegateAccessRepository {
  final DelegateAccessDataSource dataSource;

  DelegateAccessRepository({this.dataSource});

  Future<GateToken> getExternalGateToken(String accessType) async {
    return dataSource.getExternalGateToken(accessType);
  }
}
