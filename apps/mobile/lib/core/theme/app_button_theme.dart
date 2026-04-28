import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  const AppButtonTheme({
    required this.primaryStyle,
    required this.secondaryStyle,
    required this.pillStyle,
  });

  final ButtonStyle primaryStyle;
  final ButtonStyle secondaryStyle;
  final ButtonStyle pillStyle;

  @override
  AppButtonTheme copyWith({
    ButtonStyle? primaryStyle,
    ButtonStyle? secondaryStyle,
    ButtonStyle? pillStyle,
  }) {
    return AppButtonTheme(
      primaryStyle: primaryStyle ?? this.primaryStyle,
      secondaryStyle: secondaryStyle ?? this.secondaryStyle,
      pillStyle: pillStyle ?? this.pillStyle,
    );
  }

  @override
  AppButtonTheme lerp(ThemeExtension<AppButtonTheme>? other, double t) {
    if (other is! AppButtonTheme) return this;
    return AppButtonTheme(
      primaryStyle: ButtonStyle.lerp(primaryStyle, other.primaryStyle, t)!,
      secondaryStyle: ButtonStyle.lerp(
        secondaryStyle,
        other.secondaryStyle,
        t,
      )!,
      pillStyle: ButtonStyle.lerp(pillStyle, other.pillStyle, t)!,
    );
  }

  static AppButtonTheme get light => AppButtonTheme(
    primaryStyle:
        ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed))
              return AppColors.activeBlue;
            return AppColors.blue;
          }),
        ),
    secondaryStyle: ElevatedButton.styleFrom(
      backgroundColor: const Color(0x0D000000), // rgba(0,0,0,0.05)
      foregroundColor: AppColors.nearBlack,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
    ),
    pillStyle: ElevatedButton.styleFrom(
      backgroundColor: AppColors.badgeBlueBg,
      foregroundColor: AppColors.badgeBlueText,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      elevation: 0,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size.zero,
    ),
  );

  static AppButtonTheme get dark => AppButtonTheme(
    primaryStyle:
        ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed))
              return AppColors.activeBlue;
            return AppColors.blue;
          }),
        ),
    secondaryStyle: ElevatedButton.styleFrom(
      backgroundColor: const Color(0x1AFFFFFF), // rgba(255,255,255,0.1)
      foregroundColor: AppColors.warmWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
    ),
    pillStyle: ElevatedButton.styleFrom(
      backgroundColor: const Color(0x1A097FE8), // Tinted blue for dark mode
      foregroundColor: AppColors.linkLightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      elevation: 0,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size.zero,
    ),
  );
}
