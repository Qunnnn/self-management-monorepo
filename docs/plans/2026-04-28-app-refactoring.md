# App Refactoring Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor `app.dart` to improve separation of concerns by extracting global configurations into dedicated widgets and utilities.

**Architecture:** Extraction of `ReactiveFormConfig` into a `GlobalWrapper` widget and moving validation message mapping to a `BuildContext` extension.

**Tech Stack:** Flutter, Riverpod, Reactive Forms, AppLocalizations.

---

### Task 1: Create BuildContext Extension

**Files:**
- Create: [context_extensions.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/core/utils/context_extensions.dart)

- [ ] **Step 1: Create the validation extension**

```dart
import 'package:mobile/core/import/app_imports.dart';

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

- [ ] **Step 2: Commit**

```bash
git add apps/mobile/lib/core/utils/context_extensions.dart
git commit -m "refactor: add BuildContext extension for form validation"
```

---

### Task 2: Create AppGlobalWrapper

**Files:**
- Create: [app_global_wrapper.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/core/widgets/app_global_wrapper.dart)
- Modify: [index.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/core/widgets/index.dart)

- [ ] **Step 1: Create the global wrapper widget**

```dart
import 'package:mobile/core/import/app_imports.dart';
import 'package:mobile/core/utils/context_extensions.dart';

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

- [ ] **Step 2: Export the new widget**

Modify `apps/mobile/lib/core/widgets/index.dart`:
```dart
export 'app_global_wrapper.dart';
```

- [ ] **Step 3: Commit**

```bash
git add apps/mobile/lib/core/widgets/
git commit -m "refactor: create AppGlobalWrapper for global configurations"
```

---

### Task 3: Refactor App Widget

**Files:**
- Modify: [app.dart](file:///Users/Shared/side_projects/self-management-monorepo/apps/mobile/lib/app.dart)

- [ ] **Step 1: Update App widget to use the new wrapper**

```dart
import 'package:mobile/core/import/app_imports.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final preferences = ref.watch(preferencesProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: preferences.localeCode != null ? Locale(preferences.localeCode!) : null,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: preferences.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => AppGlobalWrapper(child: child!),
    );
  }
}
```

- [ ] **Step 2: Verify imports and formatting**
Run: `flutter analyze`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add apps/mobile/lib/app.dart
git commit -m "refactor: simplify App widget using AppGlobalWrapper"
```

---

### Task 4: Verification

- [ ] **Step 1: Manual Verification**
1. Launch the app.
2. Navigate to a screen with forms (e.g., Login or Task creation).
3. Trigger a validation error (e.g., leave a required field empty).
4. Verify that the correct localized error message is displayed.

- [ ] **Step 2: Final Cleanup**
1. Check for any unused imports in `app.dart`.
2. Run: `flutter format .`
