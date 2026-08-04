import 'package:flutter/material.dart';

import '../common/app_avatar.dart';
import 'clickable_card.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.imageUrl,
    this.onTap,
    this.trailing,
  });

  final String name;
  final String subtitle;
  final String? imageUrl;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClickableCard(
      onTap: onTap,
      child: Row(
        children: [
          AppAvatar(imageUrl: imageUrl, radius: 26),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 4),

                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),

          trailing ?? const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
