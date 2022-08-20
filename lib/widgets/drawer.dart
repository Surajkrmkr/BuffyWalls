import 'package:buffywalls_3/functions/accent_color.dart';
import 'package:buffywalls_3/functions/cache.dart';
import 'package:buffywalls_3/pages/about_page.dart';
import 'package:buffywalls_3/widgets/pro_dialog.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/app_details.dart';
import '../functions/share.dart';
import '../theme/dark_theme.dart';
import '../theme/my_flutter_app_icons.dart';
import '../theme/ui_color.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, this.drawerController}) : super(key: key);

  final ZoomDrawerController? drawerController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
          ? Uicolor.blackColor
          : Theme.of(context).backgroundColor,
      elevation: 0,
      child: OrientationBuilder(builder: (context, orien) {
        return Padding(
            padding: orien == Orientation.portrait
                ? const EdgeInsets.only(top: 60.0)
                : EdgeInsets.zero,
            child: ListView(
              children: [
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(AppDetails.grpTG),
                            mode: LaunchMode.externalApplication),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/shadowteam.png"),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.navigate_before,
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          drawerController?.close!();
                        },
                      )
                    ],
                  ),
                ),
                darkModeTile(context),
                amoledModeTile(context),
                accentColorTile(context),
                drawerTile(
                    context: context,
                    text: "Clear Cache",
                    icon: MyFlutterApp.cache,
                    onPressed: () {
                      MyCache.getClearCacheDialog(context);
                    }),
                drawerTile(
                    context: context,
                    text: "Share App",
                    icon: MyFlutterApp.share,
                    onPressed: () {
                      MyShare.shareApp();
                    }),
                drawerTile(
                    context: context,
                    text: "Rate App",
                    icon: MyFlutterApp.rate,
                    onPressed: () {
                      ProDialog.appIsPro
                          ? launchUrl(Uri.parse(AppDetails.proAppUrl),
                              mode: LaunchMode.externalApplication)
                          : launchUrl(Uri.parse(AppDetails.appUrl),
                              mode: LaunchMode.externalApplication);
                    }),
                drawerTile(
                    context: context,
                    text: "Other Apps",
                    icon: MyFlutterApp.otherapp,
                    onPressed: () {
                      launchUrl(Uri.parse(AppDetails.devPage),
                          mode: LaunchMode.externalApplication);
                    }),
                drawerTile(
                    context: context,
                    text: "About Us",
                    icon: MyFlutterApp.aboutus,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutPage()));
                    }),
                !ProDialog.appIsPro
                    ? drawerTile(
                        context: context,
                        text: "Go PRO",
                        icon: MyFlutterApp.buypro,
                        onPressed: () {})
                    : Container(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      'Version : ${Provider.of<AppDetails>(context).version}',
                      style: MyTextStyle.bodyTextStyleWithDefaultSize(
                          context: context),
                    ),
                  ),
                ),
              ],
            ));
      }),
    );
  }

  ListTile drawerTile(
      {BuildContext? context,
      String? text,
      IconData? icon,
      Function()? onPressed}) {
    return ListTile(
      title: Text(
        text!,
        style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
      ),
      onTap: onPressed,
      leading: Icon(
        icon!,
        color: Provider.of<DarkThemeProvider>(context!).amoledTheme
            ? Uicolor.whiteColor
            : Theme.of(context).primaryColor,
        size: 25,
      ),
    );
  }

  Widget darkModeTile(context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, darkThemeProvider, _) {
      return ListTile(
        leading: Icon(
          MyFlutterApp.darkmode,
          color: darkThemeProvider.amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).primaryColor,
          size: 25,
        ),
        onTap: () {
          darkThemeProvider.darkTheme = !darkThemeProvider.darkTheme;
        },
        trailing: Switch(
          value: darkThemeProvider.darkTheme,
          onChanged: (i) {
            darkThemeProvider.darkTheme = i;
          },
        ),
        title: Text(
          'Dark Mode',
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
        ),
      );
    });
  }

  Widget amoledModeTile(context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, darkThemeProvider, _) {
      return ListTile(
        leading: Icon(
          MyFlutterApp.amoled,
          color: darkThemeProvider.amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).primaryColor,
          size: 25,
        ),
        onTap: () {
          if (ProDialog.appIsPro) {
            darkThemeProvider.amoledTheme = !darkThemeProvider.amoledTheme;
          } else {}
        },
        trailing: ProDialog.appIsPro
            ? Switch(
                value: darkThemeProvider.amoledTheme,
                onChanged: (i) {
                  darkThemeProvider.amoledTheme = i;
                },
              )
            : Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        title: Text(
          'Amoled',
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
        ),
      );
    });
  }

  Widget accentColorTile(context) {
    return Consumer<Uicolor>(builder: (context, uiColor, _) {
      return ListTile(
        contentPadding: const EdgeInsets.only(right: 30, left: 16),
        leading: Icon(
          MyFlutterApp.color,
          color: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).primaryColor,
          size: 25,
        ),
        onTap: () {
          if (ProDialog.appIsPro) {
            MyAccentColor.getAccentColorDialog(context);
          }
        },
        trailing: ProDialog.appIsPro
            ? CircleAvatar(
                backgroundColor: uiColor.defaultAccentColor,
                radius: 15,
              )
            : Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        title: Text(
          'Accent Color',
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
        ),
      );
    });
  }
}
