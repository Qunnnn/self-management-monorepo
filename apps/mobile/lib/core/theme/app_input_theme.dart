import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppInputTheme extends ThemeExtension<AppInputTheme> {
  const AppInputTheme({
    required this.labelStyle,
    required this.disabledLabelStyle,
    required this.inputDecoration,
  });

  final TextStyle labelStyle;
  final TextStyle disabledLabelStyle;
  final InputDecoration inputDecoration;

  @override
  AppInputTheme copyWith({
    TextStyle? labelStyle,
    TextStyle? disabledLabelStyle,
    InputDecoration? inputDecoration,
  }) {
    return AppInputTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      disabledLabelStyle: disabledLabelStyle ?? this.disabledLabelStyle,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  @override
  AppInputTheme lerp(ThemeExtension<AppInputTheme>? other, double t) {
    if (other is! AppInputTheme) return this;
    return AppInputTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      disabledLabelStyle: TextStyle.lerp(
        disabledLabelStyle,
        other.disabledLabelStyle,
        t,
      )!,
      inputDecoration: t < 0.5 ? inputDecoration : other.inputDecoration,
    );
  }

  AppInputTheme merge(AppInputTheme? other) {
    if (other == null) return this;
    return AppInputTheme(
      labelStyle: labelStyle.merge(other.labelStyle),
      disabledLabelStyle: disabledLabelStyle.merge(other.disabledLabelStyle),
      inputDecoration: inputDecoration.copyWith(
        filled: other.inputDecoration.filled,
        fillColor: other.inputDecoration.fillColor,
        contentPadding: other.inputDecoration.contentPadding,
        border: other.inputDecoration.border,
        enabledBorder: other.inputDecoration.enabledBorder,
        disabledBorder: other.inputDecoration.disabledBorder,
        focusedBorder: other.inputDecoration.focusedBorder,
        errorBorder: other.inputDecoration.errorBorder,
        focusedErrorBorder: other.inputDecoration.focusedErrorBorder,
        hintStyle: other.inputDecoration.hintStyle,
        errorStyle: other.inputDecoration.errorStyle,
      ),
    );
  }

  static AppInputTheme get light => AppInputTheme(
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.nearBlack,
    ),
    disabledLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.warmGray300,
    ),
    inputDecoration: InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.all(6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.inputBorder.withAlpha(128)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.focusBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.orange, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.orange, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.warmGray300, fontSize: 16),
      errorStyle: const TextStyle(color: AppColors.orange, fontSize: 12),
    ),
  );

  static AppInputTheme get dark => AppInputTheme(
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.warmWhite,
    ),
    disabledLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.warmGray600,
    ),
    inputDecoration: InputDecoration(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.all(6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorderDark),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.inputBorderDark.withAlpha(128)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.focusBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.orange, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.orange, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.warmGray600, fontSize: 16),
      errorStyle: const TextStyle(color: AppColors.orange, fontSize: 12),
    ),
  );
}
