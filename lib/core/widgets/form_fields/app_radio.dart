import 'package:flutter/material.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.title,
  });

  final T value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: Text(title),
      contentPadding: EdgeInsets.zero,
    );
  }
}