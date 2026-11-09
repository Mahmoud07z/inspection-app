import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'inspection_app_theme_mode';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  ThemeMode build() {
    _restore();
    return ThemeMode.system;
  }

  Future<void> _restore() async {
    try {
      final saved = await _preferences.getString(_themeModeKey);
      if (saved != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (_) {
      // Keep the system theme when local preferences are unavailable.
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      await _preferences.setString(_themeModeKey, mode.name);
    } catch (_) {
      // The choice still applies for this session if persistence fails.
    }
  }
}
