import 'package:staffapp/network/model/store_occupancy_payload.dart';
import 'package:staffapp/network/model/system_status_payload.dart';
import 'package:staffapp/network/model/task_response.dart';
import 'package:staffapp/network/model/work_session_status_payload.dart';
import 'package:staffapp/network/work_session_payload.dart';

class SocketResponse {
  String type;
  dynamic payload;

  SocketResponse({this.type, this.payload});

  SocketResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        payload = getPayload(json['type'], json);

  static getPayload(String type, Map<String, dynamic> _json) {
    switch (type) {
      case "SYSTEM_STATUS":
        return SystemStatusPayload.fromJson(_json["payload"]);
      case "STORE_OCCUPATION":
        return StoreOccupancyPayload.fromJson(_json["payload"]);
      case "NUM_OF_OPEN_WORK_SESSIONS":
        return WorkSessionPayload.fromJson(_json["payload"]);
      case "MY_WORK_SESSION_STATUS":
        return WorkSessionStatusPayload.fromJson(_json["payload"]);
      case "TASK_UPDATE":
        List<TaskResponse> storeTasks = List<TaskResponse>.from(
            (_json["payload"] as List)
                .map((model) => TaskResponse.fromJson(model)));
        return storeTasks;
      case "COMPLETE_TASKS":
        List<TaskResponse> storeTasks = List<TaskResponse>.from(
            (_json["payload"] as List)
                .map((model) => TaskResponse.fromJson(model)));
        return storeTasks;
      default:
        return null;
    }
  }
}
