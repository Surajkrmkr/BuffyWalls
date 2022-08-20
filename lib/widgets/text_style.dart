import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/dark_theme.dart';

class MyTextStyle {
  static TextStyle bodyTextStyle(
          {@required double? size,
          Color? color,
          @required BuildContext? context}) =>
      GoogleFonts.lato(
          fontSize: size,
          color: Provider.of<DarkThemeProvider>(context!, listen: false)
                  .amoledTheme
              ? Uicolor.whiteColor
              : color,
          fontWeight: FontWeight.w800);

  static TextStyle bodyTextStyleWithDefaultSize(
          {@required BuildContext? context}) =>
      GoogleFonts.lato(
          color: Provider.of<DarkThemeProvider>(context!).amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).primaryColor);

  static TextStyle bottomSheetTextStyleWithDefaultSize() =>
      GoogleFonts.cairo(color: Uicolor.whiteColor);

  static TextStyle headerTextStyle(context) => GoogleFonts.cairo(
      fontSize: 25,
      color: Provider.of<Uicolor>(context).defaultAccentColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.4);
}
