import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeModeKey = 'themeMode';
  static final ThemeManager _instance = ThemeManager._();
  ThemeManager._();

  static ThemeManager get instance => _instance;

  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.dark);

  ValueNotifier<ThemeMode> get themeModeNotifier => _themeModeNotifier;
  ThemeMode get selectedThemeMode => _themeModeNotifier.value;

  static Future<void> initialise() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeModeKey);
    if (saved != null) {
      _instance._themeModeNotifier.value = ThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeMode.dark,
      );
    } else {
      _instance._themeModeNotifier.value = ThemeMode.dark;
      await prefs.setString(_themeModeKey, ThemeMode.dark.name);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }
}
