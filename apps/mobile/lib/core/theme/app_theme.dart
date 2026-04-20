import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';
import 'app_button_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.blue,
        onPrimary: AppColors.white,
        secondary: AppColors.warmGray500,
        surface: AppColors.white,
        onSurface: AppColors.nearBlack,
        error: AppColors.orange,
      ),
      textTheme: AppTextTheme.textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.whisperBorder,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.whisperBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.whisperBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.whisperBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.focusBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.all(6),
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(color: AppColors.warmGray300),
      ),
      extensions: [
        AppButtonTheme.light,
      ],
    );
  }
}
