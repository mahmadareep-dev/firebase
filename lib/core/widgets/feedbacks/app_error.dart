import 'package:flutter/material.dart';

import '../../assets/app_icons.dart';
import '../buttons/primary_button.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.error, size: 72, color: Colors.red),

            const SizedBox(height: 20),

            Text("Oops!", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 8),

            Text(message, textAlign: TextAlign.center),

            if (onRetry != null) ...[
              const SizedBox(height: 24),

              PrimaryButton(text: "Retry", onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
