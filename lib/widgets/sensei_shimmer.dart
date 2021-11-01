import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SenseiShimmer extends StatelessWidget {
  final double width;
  final double height;

  SenseiShimmer({this.width = 65, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xffF1F3F5),
      highlightColor: Color(0xffCED4DA),
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
