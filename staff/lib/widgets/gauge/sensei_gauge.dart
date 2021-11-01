import 'package:flutter/material.dart';
import 'package:staffapp/constants/shadows.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/widgets/gauge/gauge_painter.dart';

class SenseiGauge extends StatefulWidget {
  final int maxValue;
  final int value;
  final Color color;
  SenseiGauge(
      {Key key,
      @required this.maxValue,
      @required this.value,
      @required this.color})
      : super(key: key);

  @override
  _SenseiGaugeState createState() => _SenseiGaugeState();
}

class _SenseiGaugeState extends State<SenseiGauge>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double begin = 0.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.value / widget.maxValue;
    _controller.reset();
    _animation =
        Tween<double>(begin: begin, end: percentage).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        begin = percentage;
      }
    });
    _controller.forward();

    return AnimatedBuilder(
        animation: _animation,
        builder: (context, snapshot) {
          return Center(
            child: CustomPaint(
              foregroundPainter: GaugePainter(percent: _animation.value),
              child: Container(
                constraints: BoxConstraints.expand(height: 200, width: 200),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        constraints:
                            BoxConstraints.expand(height: 132, width: 132),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [primaryShadow()]),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Spacer(),
                            Text(
                              "${widget.value}",
                              style: poppins(
                                size: 23,
                                fontWeight: FontWeight.w600,
                                color: widget.color,
                              ),
                            ),
                            Text(
                              "DE ${widget.maxValue}",
                              style: poppins(
                                size: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "0%",
                                style: roboto(
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF4F575E),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "100%",
                                textAlign: TextAlign.right,
                                style: roboto(
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF4F575E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
