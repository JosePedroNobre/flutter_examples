part of 'qr_code_bloc.dart';

abstract class QrCodeState extends Equatable {
  const QrCodeState();

  @override
  List<Object> get props => [];
}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoaded extends QrCodeState {
  final GateToken gateToken;

  QrCodeLoaded(this.gateToken);

  @override
  List<Object> get props => [];
}

class QrCodeLoading extends QrCodeState {}

class QrCodeError extends QrCodeState {
  final SenseiError senseiError;
  QrCodeError({this.senseiError});
  @override
  List<Object> get props => [senseiError];
}
