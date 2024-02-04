import 'package:flutter/material.dart';

import 'common_export.dart';

ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Gilroy',
    appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        surfaceTintColor: transparent,
        elevation: 0),
    colorScheme: const ColorScheme.light(
        onBackground: foregroundLight,
        background: backgroundLight,
        primary: accent,
        secondary: secondary),
    chipTheme: const ChipThemeData(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: foregroundLight),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        selectedColor: foregroundLight,
        checkmarkColor: backgroundLight,
        secondarySelectedColor: foregroundLight));

ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Gilroy',
    appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        surfaceTintColor: transparent,
        elevation: 0),
    colorScheme: const ColorScheme.dark(
        onBackground: foregroundDark,
        background: backgroundDark,
        primary: primary,
        secondary: secondary));
