# Flutter Localization Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement ARB-based localization for the Flutter mobile application to support multiple languages and avoid hardcoded strings.

**Architecture:** Use the official Flutter `gen-l10n` tool with `.arb` files and a `BuildContext` extension for easy access to localized strings.

**Tech Stack:** Flutter, `flutter_localizations`, `intl`, ARB files.

---

### Task 1: Project Configuration

**Files:**
- Modify: `pubspec.yaml`
- Create: `l10n.yaml`
- Create: `lib/l10n/app_en.arb`

- [ ] **Step 1: Update pubspec.yaml**

Add `flutter_localizations` dependency and enable `generate: true`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  # ... other dependencies

flutter:
  generate: true
  uses-material-design: true
  # ...
```

- [ ] **Step 2: Create l10n.yaml**

Create `l10n.yaml` in the root of `apps/mobile`.

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-class: AppLocalizations
```

- [ ] **Step 3: Create initial ARB file**

Create `lib/l10n/app_en.arb` with some initial strings.

```json
{
  "@@locale": "en",
  "appTitle": "Self Management",
  "@appTitle": {
    "description": "The title of the application"
  },
  "commonSave": "Save",
  "commonCancel": "Cancel",
  "commonError": "Error",
  "commonSuccess": "Success"
}
```

- [ ] **Step 4: Run code generation**

Run: `flutter pub get` and `flutter gen-l10n`

- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "feat(l10n): initialize localization configuration and template"
```

### Task 2: Core Infrastructure

**Files:**
- Modify: `lib/core/import/packages_imports.dart`
- Modify: `lib/core/utils/context_extensions.dart`

- [ ] **Step 1: Update packages_imports.dart**

Export `AppLocalizations` in `packages_imports.dart`.

```dart
export 'package:mobile/l10n/app_localizations.dart';
```

- [ ] **Step 2: Update context_extensions.dart**

Add `l10n` shorthand to `BuildContextX`.

```dart
extension BuildContextX on BuildContext {
  // ... existing extensions
  
  // Localization shorthand
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

- [ ] **Step 3: Commit**

```bash
git add .
git commit -m "feat(l10n): add localization extension and export"
```

### Task 3: App Integration

**Files:**
- Modify: `lib/app.dart`

- [ ] **Step 1: Update MaterialApp configuration**

Include `localizationsDelegates` and `supportedLocales` in `App` widget.

```dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add .
git commit -m "feat(l10n): integrate localization into App widget"
```

### Task 4: Verification

- [ ] **Step 1: Run flutter analyze**

Run: `flutter analyze`

- [ ] **Step 2: Final Commit**

```bash
git add .
git commit -m "chore(l10n): finalize localization setup"
```
