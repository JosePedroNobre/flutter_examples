import 'package:customer/features/home/data/qr_code_datasource.dart';
import 'package:customer/network/model/gate_token.dart';
import 'package:customer/network/model/store.dart';

class QRCodeRepository {
  final QRCodeDataSource dataSource;

  QRCodeRepository({this.dataSource});

  Future<GateToken> getGateToken() => dataSource.getGateToken();
  Future<List<Store>> getStores() => dataSource.getStores();
}
