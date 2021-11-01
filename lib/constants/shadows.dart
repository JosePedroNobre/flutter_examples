import 'package:flutter/material.dart';

BoxShadow primaryShadow() {
  return BoxShadow(
    color: Color(0XFF8c939b).withOpacity(0.14),
    spreadRadius: 0,
    blurRadius: 7,
    offset: Offset(0, 6),
  );
}

BoxShadow testShadow() {
  return BoxShadow(
    color: Colors.red.withOpacity(0.90),
    spreadRadius: 0,
    blurRadius: 7,
    offset: Offset(0, 0),
  );
}
