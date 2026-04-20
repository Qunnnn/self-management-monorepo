import 'package:flutter/material.dart';
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
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.activeBlue;
          return AppColors.blue;
        }),
      ),
      child: _buildContent(context, AppColors.white),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x0D000000), // rgba(0,0,0,0.05)
        foregroundColor: AppColors.nearBlack,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
      ),
      child: _buildContent(context, AppColors.nearBlack),
    );
  }

  Widget _buildPill(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.badgeBlueBg,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.badgeBlueText),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.badgeBlueText,
                      fontWeight: FontWeight.w600,
                    ),
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
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor),
    );
  }
}
