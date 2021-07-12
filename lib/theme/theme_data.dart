import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() => ThemeData(
      iconTheme: IconThemeData(color: Colors.grey),
      accentColor: Colors.black,
      brightness: Brightness.light,
      backgroundColor: Color(0xFFFFFFFF),
      primaryColorLight: Color(0xFFFFDCF3),
      primaryColor: Color(0xFF121212),
      splashColor: Colors.black.withOpacity(0.3),
      canvasColor: Colors.transparent,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      switchTheme: SwitchThemeData(
          trackColor: isAmoled
              ? MaterialStateProperty.all(Uicolor.whiteColor.withOpacity(0.3))
              : MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
          thumbColor: isAmoled
              ? MaterialStateProperty.all(defaultAccentColor)
              : MaterialStateProperty.all(Colors.black)),
    );

ThemeData darkTheme() => ThemeData(
  canvasColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.white),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    accentColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: Color(0xFF131A38),
    primaryColorLight: Color(0xFF131A38),
    primaryColor: Color(0xFFE0E0E0),
    splashColor: Colors.black.withOpacity(0.3),
    switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
        thumbColor: MaterialStateProperty.all(defaultAccentColor)));
