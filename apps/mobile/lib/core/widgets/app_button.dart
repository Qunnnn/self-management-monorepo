import 'package:flutter/material.dart';
import '../utils/context_extensions.dart';
import '../theme/app_colors.dart';

enum AppButtonStyle { primary, secondary, pill }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.text,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final AppButtonStyle style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case AppButtonStyle.primary:
        return _buildPrimary(context);
      case AppButtonStyle.secondary:
        return _buildSecondary(context);
      case AppButtonStyle.pill:
        return _buildPill(context);
    }
  }

  Widget _buildPrimary(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: context.buttonTheme.primaryStyle,
      child: _buildContent(context, AppColors.white),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: context.buttonTheme.secondaryStyle,
      child: _buildContent(context, context.colorScheme.onSurface),
    );
  }

  Widget _buildPill(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: context.buttonTheme.pillStyle,
      child: isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.badgeBlueText),
            )
          : Text(
              text,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.badgeBlueText,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
      );
    }
    return Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(color: textColor),
    );
  }
}
