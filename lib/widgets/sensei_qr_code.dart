import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SenseiQRCode extends StatelessWidget {
  final String data;
  final double height;
  final double width;
  const SenseiQRCode({Key key, this.data, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: data != null
          ? QrImage(
              data: data,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            )
          : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
  }
}
