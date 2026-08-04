import 'package:flutter/material.dart';

import '../../assets/app_icons.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hint;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  final TextInputAction textInputAction;

  final bool enabled;

  final Iterable<String>? autofillHints;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,

      label: widget.label ?? "Password",
      hint: widget.hint ?? "Enter your password",

      obscureText: _obscure,

      keyboardType: TextInputType.visiblePassword,

      textInputAction: widget.textInputAction,

      validator: widget.validator,

      onChanged: widget.onChanged,

      enabled: widget.enabled,

      autofillHints: widget.autofillHints,

      prefixIcon: const Icon(AppIcons.password),

      suffixIcon: IconButton(
        splashRadius: 20,
        onPressed: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
        icon: Icon(_obscure ? AppIcons.visibilityOff : AppIcons.visibility),
      ),
    );
  }
}
