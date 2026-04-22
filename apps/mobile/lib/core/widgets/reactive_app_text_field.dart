import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../theme/index.dart';
import '../utils/context_extensions.dart';

class ReactiveAppTextField<T> extends StatelessWidget {
  const ReactiveAppTextField({
    required this.formControlName,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validationMessages,
    this.autofocus = false,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.enabled,
    this.theme,
    super.key,
  });

  final String formControlName;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final bool autofocus;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ReactiveFormFieldCallback<T>? onSubmitted;
  final bool? enabled;
  final AppInputTheme? theme;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = context.inputTheme.merge(theme);
    final isEnabled = enabled ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: isEnabled ? effectiveTheme.labelStyle : effectiveTheme.disabledLabelStyle,
        ),
        const SizedBox(height: AppSpacing.xs),
        ReactiveTextField<T>(
          formControlName: formControlName,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofocus: autofocus,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: isEnabled
              ? context.textTheme.bodyMedium
              : context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.disabledColor,
                  ),
          decoration: effectiveTheme.inputDecoration
              .applyDefaults(context.theme.inputDecorationTheme)
              .copyWith(
                hintText: hintText,
              ),
          validationMessages: validationMessages,
        ),
      ],
    );
  }
}
