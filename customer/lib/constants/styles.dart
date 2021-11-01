import 'package:flutter/material.dart';

TextStyle font1(
    {double size,
    Color color,
    FontWeight fontWeight,
    double height,
    double letterSpacing = 0.25}) {
  return TextStyle(
      fontSize: size,
      color: color,
      height: height,
      fontFamily: "Font1",
      fontWeight: fontWeight ?? FontWeight.w100,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none);
}

TextStyle font2(
    {double size,
    Color color,
    FontWeight fontWeight,
    double height,
    double letterSpacing = 0.25}) {
  return TextStyle(
      fontSize: size,
      height: height,
      color: color,
      fontFamily: "Font2",
      fontWeight: fontWeight ?? FontWeight.w100,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none);
}
