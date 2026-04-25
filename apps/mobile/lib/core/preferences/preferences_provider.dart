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
