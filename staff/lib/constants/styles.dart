import 'package:flutter/material.dart';

TextStyle poppins(
    {double size, Color color, FontWeight fontWeight, double letterSpacing}) {
  return TextStyle(
      fontSize: size,
      color: color,
      fontFamily: "Poppins",
      fontWeight: fontWeight ?? FontWeight.w100,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none);
}

TextStyle roboto(
    {double size,
    Color color,
    FontWeight fontWeight,
    double letterSpacing,
    double height}) {
  return TextStyle(
      fontSize: size,
      color: color,
      height: height,
      fontFamily: "Roboto",
      fontWeight: fontWeight ?? FontWeight.w100,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none);
}
