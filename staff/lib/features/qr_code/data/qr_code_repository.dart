import 'package:staffapp/features/qr_code/data/qr_code_datasource.dart';
import 'package:staffapp/network/model/gate_token.dart';

class QRCodeRepository {
  final QRCodeDataSource dataSource;

  QRCodeRepository({this.dataSource});

  Future<GateToken> getStaffGateToken() async {
    return dataSource.getStaffGateToken();
  }
}
