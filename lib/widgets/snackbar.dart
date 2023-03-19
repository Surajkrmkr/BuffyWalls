import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../theme/ui_color.dart';

class MySnackBar {
  static snackBar(BuildContext? context, String? text) =>
      ScaffoldMessenger.of(context!).showSnackBar(getSnackBar(context, text));
  static getSnackBar(BuildContext? context, String? text) => SnackBar(
        content: Text(
          text!,
          style: MyTextStyle.bodyTextStyle(
              context: context,
              size: 17,
              color: Theme.of(context!).colorScheme.onBackground),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor:
              Provider.of<Uicolor>(context, listen: false).defaultAccentColor,
          onPressed: () {},
        ),
        // margin: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).size.height - 300,
        //     right: 20,
        //     left: 20),
        backgroundColor:
            Provider.of<DarkThemeProvider>(context, listen: false).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).colorScheme.background,
      );

  static wallSnackBar(BuildContext? context, String? text) {
    showToastWidget(
        Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 3), blurRadius: 10, color: Colors.black12)
              ],
              color: Provider.of<DarkThemeProvider>(context!, listen: false)
                      .amoledTheme
                  ? Uicolor.blackColor
                  : Theme.of(context).colorScheme.background,
            ),
            child: Text(
              text!,
              style: MyTextStyle.bodyTextStyle(
                  context: context,
                  size: 17,
                  color: Theme.of(context).colorScheme.onBackground),
            )),
        context: context,
        alignment: Alignment.center,
        position: StyledToastPosition.top,
        reverseAnimation: StyledToastAnimation.scale,
        animation: StyledToastAnimation.scale);
  }
}
