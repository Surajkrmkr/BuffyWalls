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
          primary: primary,
          secondary: secondary),
    );

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
