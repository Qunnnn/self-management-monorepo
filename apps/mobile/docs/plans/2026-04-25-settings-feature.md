# Settings Feature Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a Settings feature allowing the user to select and persist their preferred Theme (System, Light, Dark) and Language (System, English, Vietnamese).

**Architecture:** Use `shared_preferences` for local persistence. Create a Riverpod `PreferencesProvider` to manage the state of theme and language. Update `MaterialApp` to consume this state. Add a `SettingsPage` accessible from the main screens.

**Tech Stack:** Flutter, Riverpod, `shared_preferences`, GoRouter.

---

### Task 1: Preferences State Management

**Files:**
- Create: `lib/core/preferences/preferences_state.dart`
- Create: `lib/core/preferences/preferences_service.dart`
- Create: `lib/core/preferences/preferences_provider.dart`
- Create: `lib/core/preferences/index.dart`
- Modify: `lib/core/import/app_imports.dart`

- [ ] **Step 1: Create PreferencesState**

```dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_state.freezed.dart';
part 'preferences_state.g.dart';

@freezed
class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    String? localeCode,
  }) = _PreferencesState;

  factory PreferencesState.fromJson(Map<String, dynamic> json) =>
      _$PreferencesStateFromJson(json);
}
```

- [ ] **Step 2: Create PreferencesService**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const _themeKey = 'app_theme_mode';
  static const _localeKey = 'app_locale_code';

  ThemeMode getThemeMode() {
    final themeStr = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeStr,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  String? getLocaleCode() {
    return _prefs.getString(_localeKey);
  }

  Future<void> setLocaleCode(String? localeCode) async {
    if (localeCode == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, localeCode);
    }
  }
}
```

- [ ] **Step 3: Create PreferencesProvider**

```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preferences_state.dart';
import 'preferences_service.dart';

part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferences provider must be overridden in main.dart');
}

@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) {
  return PreferencesService(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
class PreferencesNotifier extends _$PreferencesNotifier {
  @override
  PreferencesState build() {
    final service = ref.watch(preferencesServiceProvider);
    return PreferencesState(
      themeMode: service.getThemeMode(),
      localeCode: service.getLocaleCode(),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(preferencesServiceProvider).setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocaleCode(String? localeCode) async {
    await ref.read(preferencesServiceProvider).setLocaleCode(localeCode);
    state = state.copyWith(localeCode: localeCode);
  }
}
```

- [ ] **Step 4: Create barrel file and export**

Create `lib/core/preferences/index.dart`:
```dart
export 'preferences_state.dart';
export 'preferences_service.dart';
export 'preferences_provider.dart';
```

Modify `lib/core/import/app_imports.dart` to include `export 'package:mobile/core/preferences/index.dart';`.

- [ ] **Step 5: Run Code Generation**

Run: `make build` (or `dart run build_runner build --delete-conflicting-outputs`)
Expected: Generated files for PreferencesState and PreferencesProvider.

- [ ] **Step 6: Update main.dart**

Modify `lib/main.dart` to initialize `SharedPreferences` and override the provider.

```dart
// Modify main() function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      observers: [AppRiverpodObserver()],
      child: const App(),
    ),
  );
}
```

- [ ] **Step 7: Commit**

```bash
git add .
git commit -m "feat(settings): add preferences state management for theme and language"
```

### Task 2: App Integration & Localization Updates

**Files:**
- Modify: `lib/app.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_vi.arb`

- [ ] **Step 1: Update app.dart**

Watch `preferencesNotifierProvider` in `lib/app.dart` to apply settings.

```dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final preferences = ref.watch(preferencesNotifierProvider);

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
    );
  }
}
```

- [ ] **Step 2: Update Localization Files**

Add keys to `lib/l10n/app_en.arb`:
```json
  "settingsTitle": "Settings",
  "settingsTheme": "Theme",
  "settingsLanguage": "Language",
  "themeSystem": "System",
  "themeLight": "Light",
  "themeDark": "Dark",
  "languageSystem": "System Default",
  "languageEnglish": "English",
  "languageVietnamese": "Vietnamese"
```

Add keys to `lib/l10n/app_vi.arb`:
```json
  "settingsTitle": "Cài đặt",
  "settingsTheme": "Giao diện",
  "settingsLanguage": "Ngôn ngữ",
  "themeSystem": "Hệ thống",
  "themeLight": "Sáng",
  "themeDark": "Tối",
  "languageSystem": "Theo hệ thống",
  "languageEnglish": "Tiếng Anh",
  "languageVietnamese": "Tiếng Việt"
```

- [ ] **Step 3: Run Code Generation**

Run: `make l10n` to update generated strings.

- [ ] **Step 4: Commit**

```bash
git add .
git commit -m "feat(settings): integrate preferences into App widget and update translations"
```

### Task 3: Settings UI Construction

**Files:**
- Create: `lib/features/settings/presentation/pages/settings_page.dart`
- Create: `lib/features/settings/settings.dart`
- Modify: `lib/features/features.dart`
- Modify: `lib/core/router/app_router.dart`
- Modify: `lib/features/diary/presentation/pages/diary_page.dart`

- [ ] **Step 1: Create Settings Page**

Create `lib/features/settings/presentation/pages/settings_page.dart`:
```dart
import 'package:mobile/core/import/app_imports.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: prefs.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(preferencesNotifierProvider.notifier).setThemeMode(mode);
                }
              },
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(context.l10n.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(context.l10n.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(context.l10n.themeDark)),
              ],
            ),
          ),
          ListTile(
            title: Text(context.l10n.settingsLanguage),
            trailing: DropdownButton<String?>(
              value: prefs.localeCode,
              onChanged: (code) {
                ref.read(preferencesNotifierProvider.notifier).setLocaleCode(code);
              },
              items: [
                DropdownMenuItem(value: null, child: Text(context.l10n.languageSystem)),
                DropdownMenuItem(value: 'en', child: Text(context.l10n.languageEnglish)),
                DropdownMenuItem(value: 'vi', child: Text(context.l10n.languageVietnamese)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Export Settings Feature**

Create `lib/features/settings/settings.dart`:
```dart
export 'presentation/pages/settings_page.dart';
```

Modify `lib/features/features.dart` to add:
```dart
export 'settings/settings.dart';
```

- [ ] **Step 3: Update App Router**

Add route in `lib/core/router/app_router.dart` (inside the `routes` array of GoRouter, e.g. alongside `/login` or `/home`):
```dart
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
```

- [ ] **Step 4: Add Settings Button to Diary Page**

Modify `lib/features/diary/presentation/pages/diary_page.dart` AppBar:
```dart
      appBar: AppBar(
        title: const Text('Diary'),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.nearBlack,
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
```

- [ ] **Step 5: Run Code Generation**

Run: `make build` just in case the router provider needs updating.
Run: `make analyze` to verify.

- [ ] **Step 6: Final Commit**

```bash
git add .
git commit -m "feat(settings): create settings ui with theme and language toggles"
```
