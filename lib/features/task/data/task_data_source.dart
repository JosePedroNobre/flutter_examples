import 'dart:convert';

import 'package:staffapp/network/generic/exceptions/AppExceptions.dart';
import 'package:staffapp/network/generic/services_base_api.dart';
import 'package:staffapp/network/model/product.dart';
import 'package:staffapp/network/model/requests/archive_task_request.dart';
import 'package:staffapp/network/model/requests/complete_gap_task_request.dart';
import 'package:staffapp/network/model/requests/complete_misplacement_task_request.dart';
import 'package:staffapp/network/model/requests/complete_replenishment_task_request.dart';
import 'package:staffapp/network/model/requests/snooze_task_request.dart';
import 'package:staffapp/network/model/requests/unsaleable_task_input.dart';
import 'package:staffapp/network/model/requests/withdrawn_task_input.dart';
import 'package:staffapp/network/model/responses/product_id_response.dart';
import 'package:staffapp/network/model/sensei_error.dart';

abstract class TaskDataSource {
  archiveTask(ArchiveTaskRequest archiveTaskRequest);
  snoozeTask(SnoozeTaskRequest snoozeTaskRequest);
  completeGapTask(CompleteGapTaskRequest completeGapTaskRequest);
  completeMisplacedTask(
      CompleteMisplacementTaskRequest completeMisplacementTaskRequest);
  completeReplenishmentTask(
      CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest);

  createGapTask(CompleteGapTaskRequest completeGapTaskRequest);
  createMisplacedTask(
      CompleteMisplacementTaskRequest completeMisplacementTaskRequest);
  createReplenishmentTask(
      CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest);
  createUnsaleableTask(UnsaleableTaskInput unsaleableTaskInput);
  createWithdrawnTask(WithdrawnTaskInput withdrawnTaskInput);

  Future<int> getProductId(int storeId, String ean);
  Future<Product> getProduct(int id);
}

class TaskemoteDataSource implements TaskDataSource {
  ServicesBaseApi baseApi = ServicesBaseApi();

  @override
  archiveTask(ArchiveTaskRequest archiveTaskRequest) async {
    try {
      var body = json.encode(archiveTaskRequest);
      await baseApi.post("staffapp/task/dismiss", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  snoozeTask(SnoozeTaskRequest snoozeTaskRequest) async {
    try {
      var body = json.encode(snoozeTaskRequest);
      await baseApi.post("staffapp/task/snooze", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  completeGapTask(CompleteGapTaskRequest completeGapTaskRequest) async {
    try {
      var body = json.encode(completeGapTaskRequest);
      await baseApi.post("staffapp/task/complete/gap", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  completeMisplacedTask(
      CompleteMisplacementTaskRequest completeMisplacementTaskRequest) async {
    try {
      var body = json.encode(completeMisplacementTaskRequest);
      await baseApi.post("staffapp/task/complete/misplaced", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  completeReplenishmentTask(
      CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest) async {
    try {
      var body = json.encode(completeReplenishmentTaskRequest);
      await baseApi.post("staffapp/task/complete/replenishment", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  // Creation endpoints

  @override
  createGapTask(CompleteGapTaskRequest completeGapTaskRequest) async {
    try {
      var body = json.encode(completeGapTaskRequest);
      await baseApi.post("staffapp/task/create/gap", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  createMisplacedTask(
      CompleteMisplacementTaskRequest completeMisplacementTaskRequest) async {
    try {
      var body = json.encode(completeMisplacementTaskRequest);
      await baseApi.post("staffapp/task/create/misplaced", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  createReplenishmentTask(
      CompleteReplenishmentTaskRequest completeReplenishmentTaskRequest) async {
    try {
      var body = json.encode(completeReplenishmentTaskRequest);
      await baseApi.post("staffapp/task/create/replenishment", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  createUnsaleableTask(UnsaleableTaskInput unsaleableTaskInput) async {
    try {
      var body = json.encode(unsaleableTaskInput);
      await baseApi.post("staffapp/task/create/unsaleable", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  createWithdrawnTask(WithdrawnTaskInput withdrawnTaskInput) async {
    try {
      var body = json.encode(withdrawnTaskInput);
      await baseApi.post("staffapp/task/create/withdrawn", body, null);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    try {
      var response = await baseApi
          .get("products/$id", queryParameters: {"select": "*, image{*}"});
      return Product.fromJson(response);
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }

  @override
  Future<int> getProductId(int storeId, String ean) async {
    try {
      var response = await baseApi.get(
          "stores/$storeId/available-products/$ean",
          queryParameters: {"select": "id, product{*}"});
      return ProductIdResponse.fromJson(response).product.id;
    } catch (e) {
      if (e.response != null) {
        throw SenseiError.fromJson(e.response.data);
      } else {
        throw GenericException(dioError: e.message);
      }
    }
  }
}
