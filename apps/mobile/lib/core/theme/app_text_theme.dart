import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    const String fontFamily = 'Inter';
    return const TextTheme(
      // Display Hero (64px, 700, -2.125px tracking)
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 64,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -2.125,
        color: AppColors.nearBlack,
      ),
      // Display Secondary (54px, 700, -1.875px tracking)
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 54,
        fontWeight: FontWeight.w700,
        height: 1.04,
        letterSpacing: -1.875,
        color: AppColors.nearBlack,
      ),
      // Section Heading (48px, 700, -1.5px tracking)
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -1.5,
        color: AppColors.nearBlack,
      ),
      // Sub-heading Large (40px, 700, normal)
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: AppColors.nearBlack,
      ),
      // Sub-heading (26px, 700, -0.625px tracking)
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.23,
        letterSpacing: -0.625,
        color: AppColors.nearBlack,
      ),
      // Card Title (22px, 700, -0.25px tracking)
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.27,
        letterSpacing: -0.25,
        color: AppColors.nearBlack,
      ),
      // Body Large (20px, 600, -0.125px tracking)
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -0.125,
        color: AppColors.nearBlack,
      ),
      // Body (16px, 400, normal)
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.nearBlack,
      ),
      // Body Medium (16px, 500, normal)
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.nearBlack,
      ),
      // Nav / Button (15px, 600, normal)
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: AppColors.nearBlack,
      ),
      // Caption (14px, 500, normal)
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        color: AppColors.warmGray500,
      ),
      // Micro Label (12px, 400, 0.125px tracking)
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.125,
        color: AppColors.warmGray500,
      ),
    );
  }
}
