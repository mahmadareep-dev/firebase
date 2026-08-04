import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

class AppDecoration {
  AppDecoration._();

  static BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.radiusLG,
    boxShadow: AppShadows.sm,
  );

  static BoxDecoration elevatedCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.radiusXL,
    boxShadow: AppShadows.md,
  );

  static BoxDecoration outlined = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.radiusLG,
    border: Border.all(color: AppColors.border),
  );

  static BoxDecoration primary = BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.radiusLG,
  );

  static BoxDecoration success = BoxDecoration(
    color: AppColors.success,
    borderRadius: AppRadius.radiusLG,
  );

  static BoxDecoration error = BoxDecoration(
    color: AppColors.error,
    borderRadius: AppRadius.radiusLG,
  );

  static BoxDecoration gradient = BoxDecoration(
    borderRadius: AppRadius.radiusXL,
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.primaryDark],
    ),
  );
}
