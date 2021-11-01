import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';

class SenseiFillButton extends StatefulWidget {
  final Function onComplete;
  final Function onReboot;
  final bool activityInProgress;

  SenseiFillButton({this.onComplete, this.onReboot, this.activityInProgress});

  @override
  _SenseiFillButtonState createState() => _SenseiFillButtonState();
}

class _SenseiFillButtonState extends State<SenseiFillButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Animation _curve;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _curve = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic);
    _animation = Tween(
            begin:
                0.0, // if activity is in progress the button is not filled ( only reboot button is filled)
            end: 300.0)
        .animate(_curve)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Container(
          width: !widget.activityInProgress ? 300 : _animation.value,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0), color: Colors.black),
        ),
        GestureDetector(
          onTapUp: (details) {
            if (widget.activityInProgress) {
              _animationController.reverse();
            }
          },
          onTapDown: (c) {
            if (widget.activityInProgress) {
              // if activity is IN progress the button will turn himself into a reboot button
              _animationController
                  .forward()
                  .then((value) => widget.onComplete());
            } else {
              _animationController.reset();
              widget.onReboot();
            }
          },
          child: Container(
            width: 300,
            height: 48,
            child: Center(
              child: widget.activityInProgress
                  ? Text("Parar",
                      style: poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          size: 14))
                  : Text("Iniciar",
                      style: poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          size: 14)),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.transparent,
                border: Border.all(
                    color: !widget.activityInProgress
                        ? Colors.black26
                        : Color(0xff101213))),
          ),
        )
      ]),
    );
  }
}
