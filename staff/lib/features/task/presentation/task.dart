// mocked data ( To be replaced by API call)

import 'package:staffapp/constants/enums.dart';

List<Task> tasksTodo = [
  Task(
      id: 1,
      type: TaskType.MISPLACEMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 1,
      )),
  Task(
      id: 2,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 2,
      )),
  Task(
      id: 3,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 3,
      )),
  Task(
      id: 4,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 4,
      )),
  Task(
      id: 5,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      completedHour: "12:00",
      product: Product(
        id: 5,
      )),
  Task(
      id: 6,
      type: TaskType.MISPLACEMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 6,
      )),
  Task(
      id: 7,
      type: TaskType.MISPLACEMENT,
      currentSelectedValue: 1,
      completedHour: "10:00",
      product: Product(
        id: 7,
      )),
  Task(
      id: 8,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 8,
      ))
];

List<Task> tasksCompleted = [
  Task(
      id: 10,
      type: TaskType.MISPLACEMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 1,
      )),
  Task(
      id: 11,
      type: TaskType.REPLENISMENT,
      currentSelectedValue: 1,
      product: Product(
        id: 2,
      ))
];

class Product {
  int id;
  String image;
  String description;

  Product({this.id, this.description, this.image});
}

class Task {
  int id;
  Product product;
  TaskType type;
  String completedHour;
  int currentSelectedValue;

  Task({
    this.id,
    this.product,
    this.completedHour,
    this.type,
    this.currentSelectedValue,
  });
}
