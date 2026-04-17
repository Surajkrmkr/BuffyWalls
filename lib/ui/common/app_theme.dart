import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_export.dart';

ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Gilroy',
    appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        surfaceTintColor: transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: transparent,
          systemNavigationBarColor: transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        )),
    dialogTheme: DialogThemeData(
      backgroundColor: backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: transparent,
    ),
    colorScheme: const ColorScheme.light(
        onSurface: foregroundLight,
        surface: backgroundLight,
        primary: accent,
        secondary: secondary),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(foregroundLight)),
    iconTheme: const IconThemeData(color: foregroundLight),
    listTileTheme: const ListTileThemeData(iconColor: foregroundLight),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundDark),
            foregroundColor: WidgetStateProperty.all(foregroundDark))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(foregroundLight),
            overlayColor:
                WidgetStateProperty.all(backgroundLight.withAlpha(102)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(foregroundLight),
    )),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: foregroundLight),
    tabBarTheme: const TabBarThemeData(
        indicatorColor: foregroundLight, labelColor: foregroundLight),
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
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: transparent,
          systemNavigationBarColor: transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        )),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(foregroundDark)),
    dialogTheme: const DialogThemeData(
      backgroundColor: backgroundDark,
      surfaceTintColor: transparent,
    ),
    listTileTheme: const ListTileThemeData(iconColor: foregroundDark),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundLight),
            foregroundColor: WidgetStateProperty.all(foregroundLight))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(foregroundDark),
            overlayColor:
                WidgetStateProperty.all(backgroundDark.withAlpha(102)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(foregroundDark),
    )),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: foregroundDark),
    tabBarTheme: const TabBarThemeData(
        indicatorColor: foregroundDark, labelColor: foregroundDark),
    colorScheme: const ColorScheme.dark(
        onSurface: foregroundDark,
        surface: backgroundDark,
        primary: primary,
        secondary: secondary),
    iconTheme: const IconThemeData(color: foregroundDark),
    chipTheme: const ChipThemeData(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: foregroundDark),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        selectedColor: foregroundDark,
        checkmarkColor: backgroundDark,
        secondarySelectedColor: foregroundDark));

ThemeMode convertStringToThemeMode(String themeMode) =>
    ThemeMode.values.firstWhere(
        (element) => element.name.toLowerCase() == themeMode.toLowerCase(),
        orElse: () => ThemeMode.system);
