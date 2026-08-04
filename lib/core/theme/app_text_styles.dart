import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 34.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
    letterSpacing: -.5,
  );

  static final TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
  );

  static final TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
  );

  static final TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
  );

  static final TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.heading,
  );

  static final TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.heading,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.body,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.body,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitle,
  );

  static final TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.hint,
  );
}
