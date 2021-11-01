part of 'qr_code_bloc.dart';

abstract class QrCodeEvent extends Equatable {
  const QrCodeEvent();

  @override
  List<Object> get props => [];
}

class GetStores extends QrCodeEvent {
  @override
  List<Object> get props => [];
}

class GetQRCode extends QrCodeEvent {
  final BuildContext context;

  GetQRCode({@required this.context});

  @override
  List<Object> get props => [context];
}
