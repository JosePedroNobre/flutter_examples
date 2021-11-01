part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskActionLoading extends TaskState {}

class TaskSnoozeComplete extends TaskState {}

class TaskArchiveComplete extends TaskState {}

class TaskComplete extends TaskState {}

class TaskCreated extends TaskState {}

class ProductLoaded extends TaskState {
  final Product product;

  ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class TaskError extends TaskState {
  final SenseiError senseiError;
  TaskError({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
