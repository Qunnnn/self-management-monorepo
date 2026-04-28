import 'package:flutter/material.dart';
import '../theme/index.dart';
import '../utils/context_extensions.dart';

enum AppCardStyle { standard, featured }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.style = AppCardStyle.standard,
    this.padding,
    this.margin,
    this.onTap,
    this.enabled = true,
    this.theme,
    super.key,
  });

  final Widget child;
  final AppCardStyle style;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool enabled;
  final AppDecorationTheme? theme;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = context.decorationTheme.merge(theme);
    final decoration = enabled
        ? (style == AppCardStyle.standard
              ? effectiveTheme.cardDecoration
              : effectiveTheme.featuredCardDecoration)
        : (style == AppCardStyle.standard
              ? effectiveTheme.disabledCardDecoration
              : effectiveTheme.disabledFeaturedCardDecoration);
    final borderRadius = style == AppCardStyle.standard
        ? effectiveTheme.cardRadius
        : effectiveTheme.featuredCardRadius;

    Widget content = Container(
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.m),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
