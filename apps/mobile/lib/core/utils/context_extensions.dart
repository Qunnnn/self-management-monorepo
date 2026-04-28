import 'package:flutter/material.dart';
import '../theme/index.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Shorthand extensions for [BuildContext] to access theme and layout tokens.
extension BuildContextX on BuildContext {
  // Theme shorthand
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  AppButtonTheme get buttonTheme => theme.extension<AppButtonTheme>()!;
  AppDecorationTheme get decorationTheme =>
      theme.extension<AppDecorationTheme>()!;
  AppInputTheme get inputTheme => theme.extension<AppInputTheme>()!;
  AppShadows get shadows => theme.extension<AppShadows>()!;

  // Localization shorthand
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Spacing (Notion-inspired 8px base unit)
  double get spacingXXS => 4.0;
  double get spacingXS => 8.0;
  double get spacingSM => 12.0;
  double get spacingMD => 16.0;
  double get spacingLG => 24.0;
  double get spacingXL => 32.0;
  double get spacingXXL => 48.0;

  // Responsive shorthand
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;

  // Form Validation shorthand
  Map<String, String Function(Object)> get formValidationMessages => {
    ValidationMessage.required: (error) => l10n.validationRequiredGeneric,
    ValidationMessage.email: (error) => l10n.validationEmailGeneric,
    ValidationMessage.minLength: (error) => l10n.validationMinLengthGeneric,
    ValidationMessage.maxLength: (error) => l10n.validationMaxLengthGeneric,
    ValidationMessage.number: (error) => l10n.validationNumberGeneric,
    ValidationMessage.min: (error) => l10n.validationMinGeneric,
  };
}

/// Shorthand extensions for [Widget] to apply common layout wrappers.
extension WidgetX on Widget {
  // Padding shorthand
  Widget p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);
  Widget px(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value),
    child: this,
  );
  Widget py(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value),
    child: this,
  );
  Widget pt(double value) => Padding(
    padding: EdgeInsets.only(top: value),
    child: this,
  );
  Widget pb(double value) => Padding(
    padding: EdgeInsets.only(bottom: value),
    child: this,
  );
  Widget pl(double value) => Padding(
    padding: EdgeInsets.only(left: value),
    child: this,
  );
  Widget pr(double value) => Padding(
    padding: EdgeInsets.only(right: value),
    child: this,
  );

  // Layout shorthand
  Widget expanded([int flex = 1]) => Expanded(flex: flex, child: this);
  Widget flexible([int flex = 1, FlexFit fit = FlexFit.loose]) =>
      Flexible(flex: flex, fit: fit, child: this);
  Widget center() => Center(child: this);

  // Sizing shorthand
  Widget h(double value) => SizedBox(height: value, child: this);
  Widget w(double value) => SizedBox(width: value, child: this);

  // Visibility shorthand
  Widget visible(bool condition) => condition ? this : const SizedBox.shrink();
}

/// Shorthand extensions for [num] to create [SizedBox] spacers.
extension NumX on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
}
