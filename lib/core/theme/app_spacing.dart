import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  /// Padding
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets card = EdgeInsets.all(20);

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );
}
