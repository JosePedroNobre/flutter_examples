import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:staffapp/env/domain_controller.dart';
import 'package:staffapp/features/task/data/task_repository.dart';
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/requests/archive_task_request.dart';
import 'package:staffapp/network/model/requests/complete_gap_task_request.dart';
import 'package:staffapp/network/model/requests/complete_misplacement_task_request.dart';
import 'package:staffapp/network/model/requests/complete_replenishment_task_request.dart';
import 'package:staffapp/network/model/requests/snooze_task_request.dart';
import 'package:staffapp/network/model/requests/unsaleable_task_input.dart';
import 'package:staffapp/network/model/requests/withdrawn_task_input.dart';
import 'package:staffapp/network/model/sensei_error.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({this.repository}) : super(TaskInitial());

  final TaskRepository repository;

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is SnoozeTask) {
      yield TaskActionLoading();
      try {
        var snoozeTaskRequest = SnoozeTaskRequest(taskId: event.id);
        await repository.snoozeTask(snoozeTaskRequest);
        yield TaskSnoozeComplete();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is ArchiveTask) {
      yield TaskActionLoading();
      try {
        var archiveTaskRequest = ArchiveTaskRequest(taskId: event.id);
        await repository.archiveTask(archiveTaskRequest);
        yield TaskArchiveComplete();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }

      /// complete tasks
    } else if (event is CompleteMisplacedTask) {
      yield TaskActionLoading();
      try {
        await repository.completeMisplacedTask(event.task);
        yield TaskComplete();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CompleteGapTask) {
      yield TaskActionLoading();
      try {
        await repository.completeGapTask(event.task);
        yield TaskComplete();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CompleteReplenishmentTask) {
      yield TaskActionLoading();
      try {
        await repository.completeReplenishmentTask(event.task);
        yield TaskComplete();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    }
    // create tasks
    else if (event is CreateMisplacementTask) {
      yield TaskActionLoading();
      try {
        await repository.createMisplacedTask(event.task);
        yield TaskCreated();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CreateGapTask) {
      yield TaskActionLoading();
      try {
        await repository.createGapTask(event.task);
        yield TaskCreated();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CreateReplenishmentTask) {
      yield TaskActionLoading();
      try {
        await repository.createReplenishmentTask(event.task);
        yield TaskCreated();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CreateUnsaleableTask) {
      yield TaskActionLoading();
      try {
        await repository.createUnsaleableTask(event.task);
        yield TaskCreated();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    } else if (event is CreateWithdrawnTask) {
      yield TaskActionLoading();
      try {
        await repository.createWithdrawnTask(event.task);
        yield TaskCreated();
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    }
    // Product
    else if (event is GetProduct) {
      try {
        print("Store id" + DomainController().storeId.toString());
        int productId = await repository.getProductId(
            DomainController().storeId, event.ean);
        Product product = await repository.getProduct(productId);
        yield ProductLoaded(product);
      } catch (e) {
        yield TaskError(senseiError: e is SenseiError ? e : null);
      }
    }
  }
}
