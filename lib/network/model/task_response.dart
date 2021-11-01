import 'package:staffapp/constants/enums.dart';
import 'package:staffapp/network/model/default_task.dart';
import 'package:staffapp/network/model/gaptask.dart';
import 'package:staffapp/network/model/misplaced_task.dart';
import 'package:staffapp/network/model/replenishment_task.dart';

class TaskResponse {
  TaskType type;
  dynamic task;

  TaskResponse({this.type, this.task});

  Map<String, dynamic> toJson() => {
        'type': type.stringType(),
        'task': task,
      };

  TaskResponse.fromJson(Map<String, dynamic> json) {
    type = (json['type'] as String).toTaskType();
    task = getTask(type, json);
  }

  static getTask(TaskType type, Map<String, dynamic> json) {
    switch (type) {
      case TaskType.REPLENISMENT:
        return ReplenishmentTask.fromJson(json["task"]);
      case TaskType.GAP:
        return GapTask.fromJson(json["task"]);
      case TaskType.MISPLACEMENT:
        return MisplacedTask.fromJson(json["task"]);
      case TaskType.UNSALEABLE:
        return DefaultTask.fromJson(json["task"]);
      case TaskType.WITHDRAWN:
        return DefaultTask.fromJson(json["task"]);
      default:
        return null;
    }
  }
}
