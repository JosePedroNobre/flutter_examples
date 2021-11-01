import 'package:customer/features/receipts/data/receipts_data_source.dart';
import 'package:customer/network/model/responses/receipts_response.dart';

class ReceiptsRepository {
  final ReceiptsRemoteDataSource dataSource;

  ReceiptsRepository({this.dataSource});

  Future<ReceiptsResponse> getReceipts() => dataSource.getReceipts();
}
