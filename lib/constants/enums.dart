enum TaskType { REPLENISMENT, MISPLACEMENT, GAP, WITHDRAWN, UNSALEABLE }

extension TaskTypeInfo on TaskType {
  String stringType() {
    switch (this) {
      case TaskType.MISPLACEMENT:
        return "MISPLACED";
      case TaskType.REPLENISMENT:
        return "REPLENISHMENT";
      case TaskType.GAP:
        return "GAP";
      case TaskType.WITHDRAWN:
        return "WITHDRAWN";
      case TaskType.UNSALEABLE:
        return "UNSALEABLE";
      default:
        return "Unknown";
    }
  }

  String description() {
    switch (this) {
      case TaskType.MISPLACEMENT:
        return "Arranjo";
      case TaskType.REPLENISMENT:
        return "Reposição";
      case TaskType.GAP:
        return "Minimos";
      case TaskType.WITHDRAWN:
        return "Retirada";
      case TaskType.UNSALEABLE:
        return "Quebra";
      default:
        return "Unknown";
    }
  }

  steps() {
    switch (this) {
      case TaskType.MISPLACEMENT:
        return 2;
      default:
        return 1;
    }
  }
}

extension TaskTypeStringInfo on String {
  TaskType toTaskType() {
    switch (this) {
      case "MISPLACED":
        return TaskType.MISPLACEMENT;
      case "REPLENISHMENT":
        return TaskType.REPLENISMENT;
      case "GAP":
        return TaskType.GAP;
      case "WITHDRAWN":
        return TaskType.WITHDRAWN;
      case "UNSALEABE":
        return TaskType.UNSALEABLE;
      default:
        return TaskType.REPLENISMENT;
    }
  }
}
