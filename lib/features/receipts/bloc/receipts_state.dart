part of 'receipts_bloc.dart';

abstract class ReceiptsState extends Equatable {
  const ReceiptsState();

  @override
  List<Object> get props => [];
}

// perform get receipts
class ReceiptsInitial extends ReceiptsState {}

class ReceiptsLoading extends ReceiptsState {}

class ReceiptsLoaded extends ReceiptsState {
  final ReceiptsResponse response;

  ReceiptsLoaded({this.response});

  @override
  List<Object> get props => [response];
}

// common events
class Error extends ReceiptsState {
  final SenseiError senseiError;
  Error({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
