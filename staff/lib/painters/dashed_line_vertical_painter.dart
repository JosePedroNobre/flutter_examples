import 'package:flutter/material.dart';

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 1, dashSpace = 2, startY = 0;
    double centerX = size.width / 2;
    final paint = Paint()
      ..color = Color(0XFFF1F3F5)
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(
          Offset(centerX, startY), Offset(centerX, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
