import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.nearBlack,
              ),
        ),
        const SizedBox(height: 4),
        ReactiveTextField<T>(
          formControlName: formControlName,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofocus: autofocus,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validationMessages: validationMessages,
        ),
      ],
    );
  }
}
