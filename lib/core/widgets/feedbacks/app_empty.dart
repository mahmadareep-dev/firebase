import 'package:flutter/material.dart';

import '../../assets/app_icons.dart';
import '../buttons/primary_button.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AppIcons.info,
    this.buttonText,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72),

            const SizedBox(height: 20),

            Text(title, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 8),

            Text(subtitle, textAlign: TextAlign.center),

            if (buttonText != null) ...[
              const SizedBox(height: 24),

              PrimaryButton(text: buttonText!, onPressed: onPressed),
            ],
          ],
        ),
      ),
    );
  }
}
