import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../ui/common/common_export.dart';

class SharedPrefService {
  // final themeKey = "theme";
  late SharedPreferences prefs;

  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  // ThemeMode getThemeMode(BuildContext context) {
  //   final themeFromSF = prefs.getString(themeKey);
  //   final ThemeMode theme = convertStringToThemeMode(themeFromSF ?? 'System');
  //   return theme;
  //   // getThemeManager(context).setThemeMode(theme);
  // }

  // void setThemeMode(BuildContext context, ThemeMode theme) {
  //   getThemeManager(context).setThemeMode(theme);
  //   prefs.setString(themeKey, theme.name);
  // }
}
