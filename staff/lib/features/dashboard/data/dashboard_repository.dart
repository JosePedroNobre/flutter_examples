import 'package:staffapp/features/dashboard/data/dashboard_data_source.dart';

class DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepository({this.dataSource});

  startWorkSession() => dataSource.startWorkSession();
  stopWorkSession() => dataSource.stopWorkSession();
}
