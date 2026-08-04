import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_decoration.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation = 0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        elevation: elevation,
        color: color ?? AppColors.surface,
        borderRadius: borderRadius ?? AppDecoration.card.borderRadius,
        child: Container(
          decoration: AppDecoration.card.copyWith(
            color: color,
            borderRadius: borderRadius,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
