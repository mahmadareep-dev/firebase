import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    required this.assetPath,
    this.title,
    this.subtitle,
    this.logoSize = 80,
  });

  final String assetPath;
  final String? title;
  final String? subtitle;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(assetPath, width: logoSize, height: logoSize),

        if (title != null) ...[
          const SizedBox(height: 16),
          Text(title!, style: Theme.of(context).textTheme.headlineSmall),
        ],

        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
