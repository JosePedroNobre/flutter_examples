import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';

class ScanConfirmationButton extends StatefulWidget {
  final bool isScanning;
  final bool isEnabled;
  final Function onPressed;

  ScanConfirmationButton(
      {Key key,
      this.isScanning = false,
      @required this.isEnabled,
      @required this.onPressed})
      : super(key: key);

  @override
  _ScanConfirmationButtonState createState() => _ScanConfirmationButtonState();
}

class _ScanConfirmationButtonState extends State<ScanConfirmationButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        child: Theme(
          data: ThemeData(
            splashColor: Colors.white24,
          ),
          child: FlatButton(
              height: 40,
              color: widget.isEnabled
                  ? Theme.of(context).primaryColor
                  : Color(0XFFDEE2E6),
              padding: const EdgeInsets.all(8),
              splashColor:
                  widget.isEnabled ? Colors.white24 : Colors.transparent,
              onPressed: widget.isEnabled ? widget.onPressed : () {},
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: widget.isScanning,
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: widget.isScanning ? 0 : 1,
                    child: Text(
                      "Scan e confirmar",
                      style: poppins(
                          size: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isEnabled
                              ? Colors.white
                              : Color(0XFF8C939B)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
