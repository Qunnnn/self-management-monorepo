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
