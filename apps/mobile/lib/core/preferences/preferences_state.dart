import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_state.freezed.dart';
part 'preferences_state.g.dart';

@freezed
abstract class PreferencesState with _$PreferencesState {
  const PreferencesState._();

  const factory PreferencesState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    String? localeCode,
  }) = _PreferencesState;

  factory PreferencesState.fromJson(Map<String, dynamic> json) =>
      _$PreferencesStateFromJson(json);
}
