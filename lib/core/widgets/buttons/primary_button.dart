import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final bool isLoading;
  final bool enabled;

  final Widget? leading;
  final Widget? trailing;

  final double? width;
  final double height;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  bool get _disabled => !enabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final bgColor = _disabled
        ? AppColors.disabled
        : (backgroundColor ?? AppColors.primary);

    final fgColor = foregroundColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: _disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppRadius.radiusLG,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? SizedBox(
                  key: const ValueKey("loader"),
                  height: 22.h,
                  width: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation(fgColor),
                  ),
                )
              : Row(
                  key: const ValueKey("text"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leading != null) ...[leading!, SizedBox(width: 8.w)],
                    Flexible(
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style:
                            textStyle ??
                            AppTextStyles.labelLarge.copyWith(color: fgColor),
                      ),
                    ),
                    if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
                  ],
                ),
        ),
      ),
    );
  }
}
