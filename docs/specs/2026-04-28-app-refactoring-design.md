# 2026-04-28 App Refactoring Design

## Goal
Refactor `apps/mobile/lib/app.dart` to improve separation of concerns by extracting global configurations into dedicated widgets and utilities.

## Proposed Changes

### 1. `BuildContext` Extension for Form Validation
- **Path**: [context_extensions.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/core/utils/context_extensions.dart)
- **Purpose**: Centralize the mapping of `ReactiveForms` validation messages.
- **Implementation**:
  ```dart
  extension AppValidationX on BuildContext {
    Map<String, String Function(Object)> get formValidationMessages => {
      ValidationMessage.required: (error) => l10n.validationRequiredGeneric,
      ValidationMessage.email: (error) => l10n.validationEmailGeneric,
      ValidationMessage.minLength: (error) => l10n.validationMinLengthGeneric,
      ValidationMessage.maxLength: (error) => l10n.validationMaxLengthGeneric,
      ValidationMessage.number: (error) => l10n.validationNumberGeneric,
      ValidationMessage.min: (error) => l10n.validationMinGeneric,
    };
  }
  ```

### 2. Global Wrapper Widget
- **Path**: [app_global_wrapper.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/core/widgets/app_global_wrapper.dart)
- **Purpose**: Wrap the app content with global providers and configurations.
- **Implementation**:
  ```dart
  class AppGlobalWrapper extends StatelessWidget {
    final Widget child;
    const AppGlobalWrapper({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      return ReactiveFormConfig(
        validationMessages: context.formValidationMessages,
        child: child,
      );
    }
  }
  ```

### 3. Refactor `App` Widget
- **Path**: [app.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/app.dart)
- **Changes**:
  - Simplify the `builder` parameter of `MaterialApp.router` to use `AppGlobalWrapper`.

## Verification Plan
- **Manual Verification**: Run the app and trigger form validations (e.g., in the Login or Task creation screens) to ensure localized error messages still appear correctly.
- **Automated Tests**: Run existing widget tests to ensure no regressions in app initialization.
