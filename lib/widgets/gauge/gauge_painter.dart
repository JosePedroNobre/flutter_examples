import 'dart:math';
import 'package:flutter/material.dart';

class GaugePainter extends CustomPainter {
  GaugePainter({@required this.percent}) : super();

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    Color color = percent < 0.85
        ? Color(0XFF00CE69)
        : percent < 0.95
            ? Color(0XFFFBA74F)
            : Color(0XFFFB5354);

    Paint circleBrush = new Paint()
      ..strokeWidth = 25.0
      ..color = Color(0XFFF1F3F5)
      ..style = PaintingStyle.stroke;

    Paint elapsedBrush = new Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = color
      ..style = PaintingStyle.stroke;

    Paint whiteBrush = new Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    Paint blackBrush = new Paint()
      ..strokeWidth = 5.0
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2.2, size.height / 2.2);
    double angle = pi * percent;
    Offset smallCircleCenter = Offset(
      center.dx + radius * cos(pi + angle),
      center.dy + radius * sin(pi + angle),
    );

    Offset triangleLeft = Offset(
      (center.dx + (radius - 23) * cos(pi + angle - 0.02)),
      (center.dy + (radius - 23) * sin(pi + angle - 0.02)),
    );

    Offset triangleRight = Offset(
      (center.dx + (radius - 23) * cos(pi + angle + 0.02)),
      (center.dy + (radius - 23) * sin(pi + angle + 0.02)),
    );

    Offset triangleTop = Offset(
      (center.dx + (radius - 21.5) * cos(pi + angle)),
      (center.dy + (radius - 21.5) * sin(pi + angle)),
    );

    Rect circleRect =
        new Rect.fromCircle(center: center, radius: radius - 12.5);
    Rect rect = new Rect.fromCircle(center: center, radius: radius);

    // background stroke
    canvas.drawArc(circleRect, pi, pi, false, circleBrush);
    // progress stroke
    canvas.drawArc(rect, pi, angle, false, elapsedBrush);
    // small circle at the end of the progress stroke
    canvas.drawCircle(smallCircleCenter, 3, whiteBrush);
    canvas.drawCircle(smallCircleCenter, 7, elapsedBrush);

    canvas.drawPath(
        getTrianglePath(triangleLeft, triangleRight, triangleTop), blackBrush);
  }

  Path getTrianglePath(Offset left, Offset right, Offset top) {
    return Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
