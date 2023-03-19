import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/dark_theme.dart';
import '../theme/my_flutter_app_icons.dart';
import '../theme/ui_color.dart';

class MyScaffold {
  static Widget getScaffold({BuildContext? context, Widget? child}) => Scaffold(
        body: child,
        backgroundColor: Provider.of<DarkThemeProvider>(context!).amoledTheme
            ? Uicolor.blackColor
            : Theme.of(context).scaffoldBackgroundColor,
      );

  static getStaggeredScaffold(
      {BuildContext? context, Widget? child, String? header}) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              color: Provider.of<Uicolor>(context!).defaultAccentColor,
              icon: const Icon(
                MyFlutterApp.back,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            header!,
            style: MyTextStyle.headerTextStyle(context),
          ),
          surfaceTintColor: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.blackColor
              : Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.blackColor
              : Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 60,
        ),
        floatingActionButton:
            Provider.of<ImageViewProvider>(context).showBackToUpBtn
                ? FloatingActionButton(
                    backgroundColor:
                        Provider.of<Uicolor>(context).defaultAccentColor,
                    onPressed: () =>
                        Provider.of<ImageViewProvider>(context, listen: false)
                            .scrollToTop(),
                    child: const Icon(Icons.arrow_upward),
                  )
                : null,
        backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
            ? Uicolor.blackColor
            : Theme.of(context).scaffoldBackgroundColor,
        body: WillPopScope(
            onWillPop: () async {
              Provider.of<ImageViewProvider>(context, listen: false)
                  .setShowBackToUpBtn(false);
              return true;
            },
            child: child!));
  }

  static getImageViewScaffold({BuildContext? context, Widget? child}) =>
      Scaffold(
          backgroundColor: Provider.of<DarkThemeProvider>(context!).amoledTheme
              ? Uicolor.blackColor
              : Theme.of(context).scaffoldBackgroundColor,
          body: child);
}
