part of 'receipts_bloc.dart';

abstract class ReceiptsEvent extends Equatable {
  const ReceiptsEvent();

  @override
  List<Object> get props => [];
}

class GetReceipts extends ReceiptsEvent {
  GetReceipts();

  @override
  List<Object> get props => [];
}
