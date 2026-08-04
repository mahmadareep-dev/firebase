import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.showCounter = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final Iterable<String>? autofillHints;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onTap;

  final List<TextInputFormatter>? inputFormatters;

  final int? maxLength;

  final int maxLines;
  final int? minLines;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;

  final bool showCounter;

  final Color? fillColor;
  final Color? borderColor;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? AppRadius.radiusLG,
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.border;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,

      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      autofocus: autofocus,

      keyboardType: keyboardType,
      textInputAction: textInputAction,

      textCapitalization: textCapitalization,

      autofillHints: autofillHints,

      validator: validator,

      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,

      onTap: onTap,

      inputFormatters: inputFormatters,

      maxLength: maxLength,

      maxLines: maxLines,
      minLines: minLines,

      style: AppTextStyles.bodyMedium,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        counterText: showCounter ? null : "",

        filled: true,
        fillColor: fillColor ?? AppColors.surface,

        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

        enabledBorder: _border(border),

        focusedBorder: _border(AppColors.primary),

        errorBorder: _border(AppColors.error),

        focusedErrorBorder: _border(AppColors.error),

        disabledBorder: _border(AppColors.disabled),

        border: _border(border),
      ),
    );
  }
}
