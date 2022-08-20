import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
              color: Theme.of(context!).primaryColor),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Provider.of<Uicolor>(context).defaultAccentColor,
          onPressed: () {},
        ),
        backgroundColor:
            Provider.of<DarkThemeProvider>(context, listen: false).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).backgroundColor,
      );

  static wallSnackBar(BuildContext? context, String? text) => showTopSnackBar(
        context!,
        Material(
          borderRadius: BorderRadius.circular(25),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Provider.of<DarkThemeProvider>(context, listen: false)
                        .amoledTheme
                    ? Uicolor.blackColor
                    : Theme.of(context).primaryColorLight,
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<DarkThemeProvider>(context,
                                listen: false)
                            .amoledTheme
                        ? Uicolor.blackColor
                        : Provider.of<DarkThemeProvider>(context, listen: false)
                                .darkTheme
                            ? Colors.black
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    text!,
                    style: MyTextStyle.bodyTextStyle(
                        context: context,
                        size: 17,
                        color: Theme.of(context).primaryColor),
                  ))),
        ),
      );
}
