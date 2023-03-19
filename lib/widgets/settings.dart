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

class Settings extends StatelessWidget {
  const Settings({Key? key, this.drawerController}) : super(key: key);

  final ZoomDrawerController? drawerController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        children: [
          headerTile(context),
          darkModeTile(context),
          amoledModeTile(context),
          accentColorTile(context),
          tile(
              context: context,
              text: "Clear Cache",
              icon: MyFlutterApp.cache,
              onPressed: () {
                MyCache.getClearCacheDialog(context);
              }),
          tile(
              context: context,
              text: "Share App",
              icon: MyFlutterApp.share,
              onPressed: () {
                MyShare.shareApp();
              }),
          tile(
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
          tile(
              context: context,
              text: "Other Apps",
              icon: MyFlutterApp.otherapp,
              onPressed: () {
                launchUrl(Uri.parse(AppDetails.devPage),
                    mode: LaunchMode.externalApplication);
              }),
          tile(
              context: context,
              text: "About Us",
              icon: MyFlutterApp.aboutus,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              }),
          !ProDialog.appIsPro
              ? tile(
                  context: context,
                  text: "Go PRO",
                  icon: MyFlutterApp.buypro,
                  onPressed: () {
                    Navigator.pushNamed(context, "/proPage");
                  })
              : Container(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                'Version : ${Provider.of<AppDetails>(context).version}',
                style:
                    MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile tile(
      {BuildContext? context,
      String? text,
      IconData? icon,
      Function()? onPressed}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        text!,
        style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
      ),
      onTap: onPressed,
      leading: Icon(
        icon!,
        color: Provider.of<DarkThemeProvider>(context!).amoledTheme
            ? Uicolor.whiteColor
            : Theme.of(context).colorScheme.onBackground,
        size: 25,
      ),
    );
  }

  Widget headerTile(context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Provider.of<DarkThemeProvider>(context!).amoledTheme
                ? Uicolor.whiteColor
                : Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
          ),
          height: 5,
          width: 80,
          margin: const EdgeInsets.symmetric(vertical: 10)),
    );
  }

  Widget darkModeTile(context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, darkThemeProvider, _) {
      return ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(
          MyFlutterApp.darkmode,
          color: darkThemeProvider.amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).colorScheme.onBackground,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(
          MyFlutterApp.amoled,
          color: darkThemeProvider.amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).colorScheme.onBackground,
          size: 25,
        ),
        onTap: () {
          if (ProDialog.appIsPro) {
            darkThemeProvider.amoledTheme = !darkThemeProvider.amoledTheme;
          } else {
            Navigator.pushNamed(context, "/proPage");
          }
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
                  color: Theme.of(context).colorScheme.onBackground,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.only(right: 30, left: 16),
        leading: Icon(
          MyFlutterApp.color,
          color: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.whiteColor
              : Theme.of(context).colorScheme.onBackground,
          size: 25,
        ),
        onTap: () {
          if (ProDialog.appIsPro) {
            MyAccentColor.getAccentColorDialog(context);
          } else {
            Navigator.pushNamed(context, "/proPage");
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
                  color: Theme.of(context).colorScheme.onBackground,
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
