import 'package:flutter/material.dart';

import '../../assets/app_icons.dart';
import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({super.key, this.controller, this.onChanged, this.hint});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint ?? "Search...",
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(AppIcons.search),
      suffixIcon: controller != null
          ? ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller!,
              builder: (_, value, _) {
                if (value.text.isEmpty) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller!.clear();
                    onChanged?.call("");
                  },
                );
              },
            )
          : null,
    );
  }
}
