import 'package:flutter/material.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
  });

  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      title: Text(title),
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
