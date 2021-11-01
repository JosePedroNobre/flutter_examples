import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final double offsetRight;

  TicketClipper({@required this.offsetRight});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addArc(
        Rect.fromCircle(
            center: Offset(size.width - offsetRight, 0), radius: 4.0),
        3,
        18);

    path.addOval(Rect.fromCircle(
        center: Offset(size.width - offsetRight, size.height), radius: 4.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    this.shadow,
    @required this.clipper,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

/// Custom shadow
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    if (shadow != null) {
      var paint = shadow.toPaint();
      var clipPath = clipper.getClip(size).shift(shadow.offset);
      canvas.drawPath(clipPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
