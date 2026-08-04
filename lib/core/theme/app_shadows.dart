import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> xs = [
    BoxShadow(
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(0, 1),
      color: Color(0x08000000),
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 4),
      color: Color(0x0A000000),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 8),
      color: Color(0x12000000),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      blurRadius: 30,
      spreadRadius: 0,
      offset: Offset(0, 14),
      color: Color(0x15000000),
    ),
  ];
}
