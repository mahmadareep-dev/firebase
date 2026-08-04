import 'package:flutter/material.dart';

import 'app_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: color),

          const SizedBox(height: 12),

          Text(value, style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 4),

          Text(title),
        ],
      ),
    );
  }
}
