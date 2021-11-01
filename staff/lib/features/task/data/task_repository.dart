import 'package:staffapp/features/task/data/task_data_source.dart';
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/requests/archive_task_request.dart';
import 'package:staffapp/network/model/requests/complete_gap_task_request.dart';
import 'package:staffapp/network/model/requests/complete_misplacement_task_request.dart';
import 'package:staffapp/network/model/requests/complete_replenishment_task_request.dart';
import 'package:staffapp/network/model/requests/snooze_task_request.dart';
import 'package:staffapp/network/model/requests/unsaleable_task_input.dart';
import 'package:staffapp/network/model/requests/withdrawn_task_input.dart';

class TaskRepository {
  final TaskDataSource dataSource;

  TaskRepository({this.dataSource});

  snoozeTask(SnoozeTaskRequest snoozeTaskRequest) =>
      dataSource.snoozeTask(snoozeTaskRequest);

  archiveTask(ArchiveTaskRequest archiveTaskRequest) =>
      dataSource.archiveTask(archiveTaskRequest);

  completeGapTask(CompleteGapTaskRequest completeGapTaskRequest) =>
      dataSource.completeGapTask(completeGapTaskRequest);

  completeMisplacedTask(
          CompleteMisplacementTaskRequest completeMisplacementTaskRequest) =>
      dataSource.completeMisplacedTask(completeMisplacementTaskRequest);

  completeReplenishmentTask(
          CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest) =>
      dataSource.completeReplenishmentTask(completeReplenishmentTaskRequest);

  createGapTask(CompleteGapTaskRequest completeGapTaskRequest) =>
      dataSource.createGapTask(completeGapTaskRequest);

  createMisplacedTask(
          CompleteMisplacementTaskRequest completeMisplacementTaskRequest) =>
      dataSource.createMisplacedTask(completeMisplacementTaskRequest);

  createReplenishmentTask(
          CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest) =>
      dataSource.createReplenishmentTask(completeReplenishmentTaskRequest);

  createUnsaleableTask(UnsaleableTaskInput unsaleableTaskInput) =>
      dataSource.createUnsaleableTask(unsaleableTaskInput);

  createWithdrawnTask(WithdrawnTaskInput withdrawnTaskInput) =>
      dataSource.createWithdrawnTask(withdrawnTaskInput);

  // product

  Future<int> getProductId(int storeId, String ean) {
    return dataSource.getProductId(storeId, ean);
  }

  Future<Product> getProduct(int id) {
    return dataSource.getProduct(id);
  }
}
