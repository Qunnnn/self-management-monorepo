import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';

class AppDecorationTheme extends ThemeExtension<AppDecorationTheme> {
  const AppDecorationTheme({
    required this.cardDecoration,
    required this.featuredCardDecoration,
    required this.disabledCardDecoration,
    required this.disabledFeaturedCardDecoration,
    required this.cardRadius,
    required this.featuredCardRadius,
  });

  final BoxDecoration cardDecoration;
  final BoxDecoration featuredCardDecoration;
  final BoxDecoration disabledCardDecoration;
  final BoxDecoration disabledFeaturedCardDecoration;
  final double cardRadius;
  final double featuredCardRadius;

  @override
  AppDecorationTheme copyWith({
    BoxDecoration? cardDecoration,
    BoxDecoration? featuredCardDecoration,
    BoxDecoration? disabledCardDecoration,
    BoxDecoration? disabledFeaturedCardDecoration,
    double? cardRadius,
    double? featuredCardRadius,
  }) {
    return AppDecorationTheme(
      cardDecoration: cardDecoration ?? this.cardDecoration,
      featuredCardDecoration: featuredCardDecoration ?? this.featuredCardDecoration,
      disabledCardDecoration: disabledCardDecoration ?? this.disabledCardDecoration,
      disabledFeaturedCardDecoration:
          disabledFeaturedCardDecoration ?? this.disabledFeaturedCardDecoration,
      cardRadius: cardRadius ?? this.cardRadius,
      featuredCardRadius: featuredCardRadius ?? this.featuredCardRadius,
    );
  }

  @override
  AppDecorationTheme lerp(ThemeExtension<AppDecorationTheme>? other, double t) {
    if (other is! AppDecorationTheme) return this;
    return AppDecorationTheme(
      cardDecoration: BoxDecoration.lerp(cardDecoration, other.cardDecoration, t)!,
      featuredCardDecoration:
          BoxDecoration.lerp(featuredCardDecoration, other.featuredCardDecoration, t)!,
      disabledCardDecoration:
          BoxDecoration.lerp(disabledCardDecoration, other.disabledCardDecoration, t)!,
      disabledFeaturedCardDecoration: BoxDecoration.lerp(
          disabledFeaturedCardDecoration, other.disabledFeaturedCardDecoration, t)!,
      cardRadius: t < 0.5 ? cardRadius : other.cardRadius,
      featuredCardRadius: t < 0.5 ? featuredCardRadius : other.featuredCardRadius,
    );
  }

  AppDecorationTheme merge(AppDecorationTheme? other) {
    if (other == null) return this;
    return AppDecorationTheme(
      cardDecoration: cardDecoration.copyWith(
        color: other.cardDecoration.color,
        border: other.cardDecoration.border,
        boxShadow: other.cardDecoration.boxShadow,
        borderRadius: other.cardDecoration.borderRadius,
      ),
      featuredCardDecoration: featuredCardDecoration.copyWith(
        color: other.featuredCardDecoration.color,
        border: other.featuredCardDecoration.border,
        boxShadow: other.featuredCardDecoration.boxShadow,
        borderRadius: other.featuredCardDecoration.borderRadius,
      ),
      disabledCardDecoration: disabledCardDecoration.copyWith(
        color: other.disabledCardDecoration.color,
        border: other.disabledCardDecoration.border,
        boxShadow: other.disabledCardDecoration.boxShadow,
        borderRadius: other.disabledCardDecoration.borderRadius,
      ),
      disabledFeaturedCardDecoration: disabledFeaturedCardDecoration.copyWith(
        color: other.disabledFeaturedCardDecoration.color,
        border: other.disabledFeaturedCardDecoration.border,
        boxShadow: other.disabledFeaturedCardDecoration.boxShadow,
        borderRadius: other.disabledFeaturedCardDecoration.borderRadius,
      ),
      cardRadius: other.cardRadius != AppSpacing.sm ? other.cardRadius : cardRadius,
      featuredCardRadius:
          other.featuredCardRadius != AppSpacing.m ? other.featuredCardRadius : featuredCardRadius,
    );
  }

  static AppDecorationTheme get light => AppDecorationTheme(
        cardRadius: AppSpacing.sm,
        featuredCardRadius: AppSpacing.m,
        cardDecoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.whisperBorder),
          boxShadow: AppShadows.light.cardShadow,
        ),
        featuredCardDecoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.m),
          border: Border.all(color: AppColors.whisperBorder),
          boxShadow: AppShadows.light.deepShadow,
        ),
        disabledCardDecoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.whisperBorder.withAlpha(128)),
        ),
        disabledFeaturedCardDecoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(AppSpacing.m),
          border: Border.all(color: AppColors.whisperBorder.withAlpha(128)),
        ),
      );

  static AppDecorationTheme get dark => AppDecorationTheme(
        cardRadius: AppSpacing.sm,
        featuredCardRadius: AppSpacing.m,
        cardDecoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.whisperBorderDark),
          boxShadow: AppShadows.dark.cardShadow,
        ),
        featuredCardDecoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppSpacing.m),
          border: Border.all(color: AppColors.whisperBorderDark),
          boxShadow: AppShadows.dark.deepShadow,
        ),
        disabledCardDecoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.whisperBorderDark.withAlpha(128)),
        ),
        disabledFeaturedCardDecoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(AppSpacing.m),
          border: Border.all(color: AppColors.whisperBorderDark.withAlpha(128)),
        ),
      );
}
