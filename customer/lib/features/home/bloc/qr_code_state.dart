part of 'qr_code_bloc.dart';

abstract class QrCodeState extends Equatable {
  const QrCodeState();

  @override
  List<Object> get props => [];
}

class QrCodeScreenInitial extends QrCodeState {}

class QrCodeScreenError extends QrCodeState {
  final SenseiError senseiError;
  QrCodeScreenError({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}

class StoresLoading extends QrCodeState {}

class StoresLoaded extends QrCodeState {
  final List<Store> stores;

  StoresLoaded(this.stores);
}

class QRCodeLoading extends QrCodeState {}

class QRCodeLoaded extends QrCodeState {
  final GateToken gateToken;

  QRCodeLoaded(this.gateToken);
}
