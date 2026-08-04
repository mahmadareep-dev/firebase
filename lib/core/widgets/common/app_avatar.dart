import 'package:flutter/material.dart';

import '../../assets/app_icons.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.backgroundColor,
    this.placeholderIcon = AppIcons.person,
  });

  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Icon(placeholderIcon, size: radius)
          : null,
    );
  }
}
