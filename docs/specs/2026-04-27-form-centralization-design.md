# Design Spec: Form Centralization and Localization

Centralize form control names and validation messages to improve maintainability and ensure full localization across the application.

## Problem Statement
Currently, form control names (e.g., `'email'`, `'password'`) and validation messages (e.g., `'Email is required'`) are hardcoded as strings across multiple files. This leads to:
1.  **Inconsistency**: Different forms might use different strings for the same purpose.
2.  **Maintenance Overhead**: Changing a field name requires manual updates in multiple places.
3.  **Missing Localization**: Validation messages are currently in English only and scattered throughout the UI code.

## Proposed Changes

### 1. Centralized Form Controls
We will use a tiered approach for form control names:

#### Core Controls (`lib/core/constants/form_controls.dart`)
Common fields used across multiple features.
```dart
class AppFormControls {
  static const String email = 'email';
  static const String password = 'password';
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String category = 'category';
  static const String type = 'type';
}
```

#### Feature Controls
Specific fields unique to a feature.
- **Auth**: `confirmPassword`, `resetToken`
- **Tasks**: `dueDate`, `priority`, `isCompleted`
- **Diary**: `mood`, `content`

### 2. Localized Validation Messages
We will add dynamic validation keys to `app_en.arb` and `app_vi.arb`.

```json
"validationRequired": "{field} is required",
"validationEmail": "Enter a valid {field}",
"validationMinLength": "{field} must be at least {count} characters",
"validationMaxLength": "{field} must be at most {count} characters",
"validationNumber": "{field} must be a number"
```

### 3. Automated Validation in `ReactiveAppTextField`
Update `lib/core/widgets/reactive_app_text_field.dart` to provide default localized messages.

```dart
Map<String, ValidationMessageFunction> _defaultValidationMessages(BuildContext context) {
  final fieldName = label ?? formControlName;
  return {
    ValidationMessage.required: (error) => context.l10n.validationRequired(fieldName),
    ValidationMessage.email: (error) => context.l10n.validationEmail(fieldName),
    ValidationMessage.minLength: (error) => context.l10n.validationMinLength(
          fieldName,
          (error as Map)['requiredLength'].toString(),
        ),
    ValidationMessage.maxLength: (error) => context.l10n.validationMaxLength(
          fieldName,
          (error as Map)['requiredLength'].toString(),
        ),
    ValidationMessage.number: (error) => context.l10n.validationNumber(fieldName),
  };
}
```

### 4. Refactoring Existing Forms
The following forms will be updated:
- `auth/presentation/pages/login_page.dart`
- `auth/presentation/pages/forgot_password_page.dart`
- `tasks/presentation/widgets/create_task_bottom_sheet.dart`
- `finance/presentation/widgets/add_transaction_bottom_sheet.dart`
- `diary/presentation/pages/entry_editor_page.dart`

## Verification Plan

### Manual Verification
1.  **Functionality**: Ensure all forms still work correctly (login, task creation, etc.).
2.  **Localization**: Switch app language to Vietnamese and verify that validation messages are correctly translated (e.g., "Email là bắt buộc").
3.  **Placeholders**: Verify that the field name is correctly injected into the message (e.g., "Password must be at least 6 characters").

### Automated Tests
1.  Run existing widget tests if available.
2.  Add a simple unit test for the validation message generation logic.
