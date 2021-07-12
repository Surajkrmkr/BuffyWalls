import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextStyle {
  static TextStyle bodyTextStyle({@required double? size, Color? color}) =>
      GoogleFonts.lato(
          fontSize: size,
          color: isAmoled ? Uicolor.whiteColor : color,
          fontWeight: FontWeight.w800);

  static TextStyle bodyTextStyleWithDefaultSize() => GoogleFonts.lato(
      color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor);

  static TextStyle bottomSheetTextStyleWithDefaultSize() =>
      GoogleFonts.cairo(color: Uicolor.whiteColor);

  static TextStyle headerTextStyle() => GoogleFonts.cairo(
      fontSize: 25,
      color: defaultAccentColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.4);
}
