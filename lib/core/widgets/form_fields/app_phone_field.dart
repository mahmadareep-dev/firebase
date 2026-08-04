import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_text_field.dart';

class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label ?? "Phone Number",
      hint: hint ?? "Enter phone number",
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      autofillHints: const [AutofillHints.telephoneNumber],
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          widthFactor: 1,
          child: Text("+91", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}
