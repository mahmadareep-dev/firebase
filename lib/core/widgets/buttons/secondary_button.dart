import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final bool enabled;
  final bool isLoading;

  final Widget? leading;
  final Widget? trailing;

  final double? width;
  final double height;

  final Color? borderColor;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final double borderWidth;

  final BorderRadius? borderRadius;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry? padding;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.width,
    this.height = 56,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 1.2,
    this.borderRadius,
    this.textStyle,
    this.padding,
  });

  bool get _disabled => !enabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final Color border =
        borderColor ?? (_disabled ? AppColors.disabled : AppColors.primary);

    final Color textColor =
        foregroundColor ?? (_disabled ? AppColors.disabled : AppColors.primary);

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: OutlinedButton(
        onPressed: _disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.surface,
          padding: padding,
          side: BorderSide(color: border, width: borderWidth),
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
                    valueColor: AlwaysStoppedAnimation(textColor),
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
                            AppTextStyles.labelLarge.copyWith(color: textColor),
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
