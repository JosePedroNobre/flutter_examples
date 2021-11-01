import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/features/qr_code/bloc/qr_code_bloc.dart';
import 'package:staffapp/widgets/sensei_qr_code.dart';

class QRCodeScreen extends StatefulWidget {
  QRCodeScreen({Key key}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  void initState() {
    BlocProvider.of<QrCodeBloc>(context).add(GetQRCode(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5E5E5),
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Acesso",
            style: poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              size: 16,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 10, right: 24),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQRCode(),
        SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Color(0XFFCED4DA)),
            SizedBox(width: 8),
            Text(
              "Scan o código para entrar".toUpperCase(),
              style: poppins(
                  size: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.25,
                  color: Color(0XFFCED4DA)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    return BlocConsumer<QrCodeBloc, QrCodeState>(
      cubit: BlocProvider.of<QrCodeBloc>(context),
      listenWhen: (previous, current) => null,
      listener: (context, state) => null,
      buildWhen: (previous, current) =>
          (current is QrCodeInitial) ||
          (current is QrCodeLoading) ||
          (current is QrCodeLoaded),
      builder: (context, state) {
        if (state is QrCodeLoaded) {
          return SenseiQRCode(
            data: state.gateToken.token,
            height: 235,
            width: 235,
          );
        } else if (state is QrCodeLoading) {
          return SenseiQRCode(
            data: null,
            height: 235,
            width: 235,
          );
        } else if (state is QrCodeError) {
          // TODO: Handle QRCode errors here.
          return Center(
              child: Text(state.senseiError?.message ?? "An error occurred"));
        } else
          return Container();
      },
    );
  }
}
