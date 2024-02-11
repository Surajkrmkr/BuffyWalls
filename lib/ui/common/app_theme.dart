import 'package:flutter/material.dart';

import 'common_export.dart';

ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Gilroy',
    appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        surfaceTintColor: transparent,
        elevation: 0),
    dialogBackgroundColor: backgroundLight,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: transparent,
    ),
    colorScheme: const ColorScheme.light(
        onBackground: foregroundLight,
        background: backgroundLight,
        primary: accent,
        secondary: secondary),
    radioTheme:
        RadioThemeData(fillColor: MaterialStateProperty.all(foregroundLight)),
    iconTheme: const IconThemeData(color: foregroundLight),
    listTileTheme: const ListTileThemeData(iconColor: foregroundLight),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundDark),
            foregroundColor: MaterialStateProperty.all(foregroundDark))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(foregroundLight),
            overlayColor:
                MaterialStateProperty.all(backgroundLight.withOpacity(0.4)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(foregroundLight),
    )),
    tabBarTheme: const TabBarTheme(
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
        elevation: 0),
    radioTheme:
        RadioThemeData(fillColor: MaterialStateProperty.all(foregroundDark)),
    dialogBackgroundColor: backgroundDark,
    dialogTheme: const DialogTheme(surfaceTintColor: transparent),
    listTileTheme: const ListTileThemeData(iconColor: foregroundDark),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundLight),
            foregroundColor: MaterialStateProperty.all(foregroundLight))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(foregroundDark),
            overlayColor:
                MaterialStateProperty.all(backgroundDark.withOpacity(0.4)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(foregroundDark),
    )),
    tabBarTheme: const TabBarTheme(
        indicatorColor: foregroundDark, labelColor: foregroundDark),
    colorScheme: const ColorScheme.dark(
        onBackground: foregroundDark,
        background: backgroundDark,
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
