import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';

class CancelButton extends StatelessWidget {
  final bool isScanning;
  final Function onPressed;
  const CancelButton({Key key, this.isScanning, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Colors.black26),
      child: FlatButton(
        padding: const EdgeInsets.all(8),
        height: 40,
        minWidth: 40,
        onPressed: isScanning ? null : onPressed,
        child: Text(
          "Cancel",
          style: poppins(
              fontWeight: FontWeight.bold,
              color: isScanning ? Color(0XFFDEE2E6) : Colors.black,
              size: 14),
        ),
      ),
    );
  }
}
