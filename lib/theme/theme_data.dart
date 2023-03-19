import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDataStyle {
  // static const bool isAmoled = false;
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      // canvasColor: Provider.of<DarkThemeProvider>(context).amoledTheme
      //     ? Uicolor.blackColor
      //     : isDarkTheme
      //         ? const Color(0xFF121212)
      //         : const Color(0xFFFFFFFF),
      // iconTheme: const IconThemeData(color: Colors.grey),
      useMaterial3: true,
      colorScheme: isDarkTheme
          ? ColorScheme.fromSeed(
              seedColor: Provider.of<Uicolor>(context).defaultAccentColor,
              brightness: Brightness.dark)
          : ColorScheme.fromSeed(
              seedColor: Provider.of<Uicolor>(context).defaultAccentColor,
              brightness: Brightness.light),
      // primaryColor: isDarkTheme
      //     ? const Color.fromARGB(255, 255, 255, 255)
      //     : const Color(0xFF121212),
      // primaryColorLight: isDarkTheme
      //     ? const Color.fromARGB(255, 36, 36, 36)
      //     : const Color(0xFFFFFFFF),
      // primaryColorDark: const Color.fromARGB(255, 36, 36, 36),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          linearTrackColor: Colors.white30,
          color: Provider.of<Uicolor>(context).defaultAccentColor),
      // bottomSheetTheme:
      //     const BottomSheetThemeData(backgroundColor: Colors.transparent),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.blackColor
              : Theme.of(context).bottomSheetTheme.backgroundColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Provider.of<Uicolor>(context)
              .defaultAccentColor
              .withOpacity(0.3)),
          backgroundColor: MaterialStateProperty.all(
              Provider.of<Uicolor>(context).defaultAccentColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Provider.of<Uicolor>(context)
              .defaultAccentColor
              .withOpacity(0.3)),
          foregroundColor: MaterialStateProperty.all(
              Provider.of<Uicolor>(context).defaultAccentColor),
        ),
      ),
      highlightColor:
          Provider.of<Uicolor>(context).defaultAccentColor.withOpacity(0.3),
      splashColor:
          Provider.of<Uicolor>(context).defaultAccentColor.withOpacity(0.3),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Provider.of<Uicolor>(context)
              .defaultAccentColor
              .withOpacity(0.3)),
          foregroundColor: MaterialStateProperty.all(
              Provider.of<Uicolor>(context).defaultAccentColor),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(
              Provider.of<Uicolor>(context).defaultAccentColor),
          radius: const Radius.circular(100),
          crossAxisMargin: 5),
      switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.all(Provider.of<Uicolor>(context)
              .defaultAccentColor
              .withOpacity(0.3)),
          thumbColor: MaterialStateProperty.all(
              Provider.of<Uicolor>(context).defaultAccentColor)),
      // dialogBackgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
      //     ? Uicolor.blackColor
      //     : isDarkTheme
      //         ? const Color(0xFF121212)
      //         : const Color(0xFFFFFFFF),
    );
  }

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final int alpha = color.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };

    return MaterialColor(color.value, shades);
  }
}
