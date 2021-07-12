import 'package:buffywalls/controller/drawer_controller.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/dark_mode.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/pages/about_page.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/clear_cache.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/share.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  final MyDarkMode myDarkMode = Get.find();
  final AppDetails details = Get.find();
  final MyDrawerController drawerController = Get.find();
  final NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.65,
      child: Drawer(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => launch(AppDetails.grpTG),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/shadowteam.png"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                      ),
                      onPressed: () {
                        drawerController.drawerController.close!();
                      },
                    )
                  ],
                ),
              ),
              Divider(),
              DarkModeTile(
                  myDarkMode: myDarkMode,
                  navigationController: navigationController),

              AmoledTile(navigationController: navigationController),
              // AccentColorPickerTile(
              //       navigationController: navigationController),
              ListTile(
                title: Text(
                  'Clear Cache',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
                onTap: () => clearCache(),
                leading: Icon(
                  MyFlutterApp.cache,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 25,
                ),
              ),
              ListTile(
                leading: Icon(
                  MyFlutterApp.share,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 25,
                ),
                onTap: () {
                  shareApp();
                },
                title: Text(
                  'Share Our App',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  MyFlutterApp.rate,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 25,
                ),
                onTap: () {
                  ProDialog.appIsPro
                      ? launch(AppDetails.proAppUrl)
                      : launch(AppDetails.appUrl);
                },
                title: Text(
                  'Rate the app',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  MyFlutterApp.otherapp,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 25,
                ),
                onTap: () {
                  launch(AppDetails.devPage);
                },
                title: Text(
                  'Other apps',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                ),
              ),
              ListTile(
                leading: Icon(
                  MyFlutterApp.aboutus,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 23,
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
              ),
              !ProDialog.appIsPro
                  ? ListTile(
                      leading: Icon(
                        MyFlutterApp.buypro,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                        size: 25,
                      ),
                      onTap: () {
                        ProDialog().getProDialog();
                      },
                      title: Text(
                        'Go pro',
                        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                      ),
                    )
                  : Container(),
              Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      'Version : ' + details.version.value,
                      style: MyTextStyle.bodyTextStyleWithDefaultSize(),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
