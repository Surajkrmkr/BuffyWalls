import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/dark_mode.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/pages/about_page.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/share.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/clear_cache.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  // final MyDarkMode myDarkMode = Get.put(MyDarkMode());
  final MyDarkMode myDarkMode = Get.find();
  final AppDetails details = Get.find();

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();
    return Scaffold(
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      body: DoubleBack(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                child: Text('Settings', style: MyTextStyle.headerTextStyle()),
              ),
              ListTile(
                title: Text(
                  'Clear Cache',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                subtitle: Text(
                  'Remove the thumbnails of loadeded images',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                onTap: () => clearCache(),
                leading: Icon(
                  Typicons.doc_text,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 30,
                ),
              ),
              // Obx(() {
              //   return
              DarkModeTile(
                  myDarkMode: myDarkMode,
                  navigationController: navigationController),
              // }),
              AmoledTile(navigationController: navigationController),
              AccentColorPickerTile(navigationController: navigationController),

              ListTile(
                leading: Icon(
                  Typicons.flow_split,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  shareApp();
                },
                title: Text(
                  'Share Our App',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                subtitle: Text(
                  'Share our Cool wallpaper App',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  Typicons.thumbs_up,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  ProDialog.appIsPro
                      ? launch(AppDetails.proAppUrl)
                      : launch(AppDetails.appUrl);
                },
                title: Text(
                  'Rate Us',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                subtitle: Text(
                  'Give us feedback',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  Typicons.attention,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  launch(AppDetails.devPage);
                },
                title: Text(
                  'Other apps',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                subtitle: Text(
                  'Try our other cool apps',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  Typicons.user_outline,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  Get.to(AboutPage(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 500));
                },
                title: Text(
                  'About Us',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                subtitle: Text(
                  'Want to know about us',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              !ProDialog.appIsPro
                  ? ListTile(
                      leading: Icon(
                        Typicons.infinity,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                        size: 30,
                      ),
                      onTap: () {
                        ProDialog().getProDialog();
                      },
                      title: Text(
                        'Go pro',
                        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                      ),
                      subtitle: Text(
                        'Access to everything',
                        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                      ),
                    )
                  : Container(),
              Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Version : ' + details.version.value,
                      style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                    ),
                  ),
                );
              })
            ],
          ),
        )),
      ),
    );
  }
}
