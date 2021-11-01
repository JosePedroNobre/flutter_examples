part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class SnoozeTask extends TaskEvent {
  final int id;

  SnoozeTask({this.id});

  @override
  List<Object> get props => [id];
}

class ArchiveTask extends TaskEvent {
  final int id;

  ArchiveTask({this.id});

  @override
  List<Object> get props => [id];
}

class CompleteMisplacedTask extends TaskEvent {
  final CompleteMisplacementTaskRequest task;

  CompleteMisplacedTask(this.task);

  @override
  List<Object> get props => [task];
}

class CompleteGapTask extends TaskEvent {
  final CompleteGapTaskRequest task;

  CompleteGapTask(this.task);

  @override
  List<Object> get props => [task];
}

class CompleteReplenishmentTask extends TaskEvent {
  final CompleteReplenishmentTaskRequest task;

  CompleteReplenishmentTask(this.task);

  @override
  List<Object> get props => [task];
}

// Creation events

class CreateMisplacementTask extends TaskEvent {
  final CompleteMisplacementTaskRequest task;

  CreateMisplacementTask(this.task);

  @override
  List<Object> get props => [task];
}

class CreateGapTask extends TaskEvent {
  final CompleteGapTaskRequest task;

  CreateGapTask(this.task);

  @override
  List<Object> get props => [task];
}

class CreateReplenishmentTask extends TaskEvent {
  final CompleteReplenishmentTaskRequest task;

  CreateReplenishmentTask(this.task);

  @override
  List<Object> get props => [task];
}

class CreateUnsaleableTask extends TaskEvent {
  final UnsaleableTaskInput task;

  CreateUnsaleableTask(this.task);

  @override
  List<Object> get props => [task];
}

class CreateWithdrawnTask extends TaskEvent {
  final WithdrawnTaskInput task;

  CreateWithdrawnTask(this.task);

  @override
  List<Object> get props => [task];
}

class GetProduct extends TaskEvent {
  final String ean;

  GetProduct(this.ean);

  @override
  List<Object> get props => [ean];
}
