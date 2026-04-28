import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../theme/index.dart';
import '../utils/context_extensions.dart';

class ReactiveAppTextField<T> extends StatelessWidget {
  const ReactiveAppTextField({
    required this.formControlName,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validationMessages,
    this.autofocus = false,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.enabled,
    this.theme,
    this.prefixIcon,
    this.decoration,
    super.key,
  });

  final String formControlName;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final bool autofocus;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ReactiveFormFieldCallback<T>? onSubmitted;
  final ReactiveFormFieldCallback<T>? onChanged;
  final bool? enabled;
  final AppInputTheme? theme;
  final Widget? prefixIcon;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = context.inputTheme.merge(theme);
    final isEnabled = enabled ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: isEnabled
                ? effectiveTheme.labelStyle
                : effectiveTheme.disabledLabelStyle,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        ReactiveTextField<T>(
          formControlName: formControlName,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofocus: autofocus,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          style: isEnabled
              ? context.textTheme.bodyMedium
              : context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.disabledColor,
                ),
          decoration: (decoration ?? effectiveTheme.inputDecoration)
              .applyDefaults(context.theme.inputDecorationTheme)
              .copyWith(hintText: hintText, prefixIcon: prefixIcon),
          validationMessages: validationMessages,
        ),
      ],
    );
  }
}
