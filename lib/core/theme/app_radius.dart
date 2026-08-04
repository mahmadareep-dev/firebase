import 'package:flutter/widgets.dart';

class AppRadius {
  AppRadius._();

  static const double xs = 6;

  static const double sm = 8;

  static const double md = 12;

  static const double lg = 16;

  static const double xl = 20;

  static const double xxl = 24;

  static const double round = 100;

  static BorderRadius get radiusXS => BorderRadius.circular(xs);

  static BorderRadius get radiusSM => BorderRadius.circular(sm);

  static BorderRadius get radiusMD => BorderRadius.circular(md);

  static BorderRadius get radiusLG => BorderRadius.circular(lg);

  static BorderRadius get radiusXL => BorderRadius.circular(xl);

  static BorderRadius get radiusXXL => BorderRadius.circular(xxl);

  static BorderRadius get circular => BorderRadius.circular(round);
}
