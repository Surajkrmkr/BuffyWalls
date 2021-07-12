import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/share.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttericon/typicons_icons.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: IconButton(
                          splashColor: defaultAccentColor.withOpacity(0.3),
                          color: defaultAccentColor,
                          icon: Icon(
                            MyFlutterApp.back,
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                    Align(
                      child: Text(
                        'About',
                        style: MyTextStyle.headerTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: AssetImage('assets/shadowteam.png')),
                    Text(
                      'Team Shadow',
                      style: MyTextStyle.bodyTextStyle(
                          size: 23,
                          color: isAmoled
                              ? Uicolor.whiteColor
                              : Get.theme.primaryColor),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text(
                        'The aim of this application is to provide you stock and some cool categorised wallpapers ',
                        style: MyTextStyle.bodyTextStyle(
                            size: 18,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        iconSize: 35,
                        icon: Icon(FontAwesome5.facebook,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor),
                        onPressed: () {
                          launch(AppDetails.fbHandle);
                        }),
                    IconButton(
                        iconSize: 35,
                        icon: Icon(FontAwesome5.twitter,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor),
                        onPressed: () {
                          launch(AppDetails.twitterHandle);
                        }),
                    IconButton(
                        iconSize: 35,
                        icon: Icon(Entypo.instagram,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor),
                        onPressed: () {
                          launch(AppDetails.instaHandle);
                        })
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Follow us for the latest updates',
                    style: MyTextStyle.bodyTextStyle(
                        size: 18,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Text(
                  'Support',
                  style: MyTextStyle.bodyTextStyle(
                      size: 18,
                      color: isAmoled
                          ? Uicolor.whiteColor
                          : Get.theme.primaryColor),
                ),
              ),
              ListBody(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        launch(AppDetails.grpTG);
                      },
                      leading: Icon(
                        Typicons.user_add,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                        size: 33,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'FAQ',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor),
                      ),
                      subtitle: Text(
                        'Join our community at Telegram',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor.withOpacity(0.7)),
                      )),
                  ListTile(
                      onTap: () {
                        launch(AppDetails.mailID);
                      },
                      leading: Icon(
                        Typicons.warning,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                        size: 33,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'Report Bugs',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: isAmoled
                              ? Uicolor.whiteColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'Let us know where you find difficulty',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: isAmoled
                              ? Uicolor.whiteColor
                              : Get.theme.primaryColor.withOpacity(0.6),
                        ),
                      )),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.share,
                  color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  size: 33,
                ),
                title: Text(
                  'Share Us',
                  style: TextStyle(
                    fontFamily: 'Body',
                    color:
                        isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
                  ),
                ),
                subtitle: Text(
                  'Share our Cool wallpaper App',
                  style: TextStyle(
                    fontFamily: 'Body',
                    color: isAmoled
                        ? Uicolor.whiteColor
                        : Get.theme.primaryColor.withOpacity(0.6),
                  ),
                ),
                onTap: () {
                  shareApp();
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Text('Creators',
                    style: MyTextStyle.bodyTextStyle(
                      size: 18,
                      color: isAmoled
                          ? Uicolor.whiteColor
                          : Get.theme.primaryColor,
                    )),
              ),
              ListBody(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        launch(AppDetails.surajTG);
                      },
                      leading: ClipOval(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset(
                            'assets/suraj.jpg',
                            height: 40,
                            fit: BoxFit.cover,
                          )),
                      trailing: Icon(
                        Typicons.right_open,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'Suraj karmakar',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: isAmoled
                              ? Uicolor.whiteColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'Student >> Android Developer',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor.withOpacity(0.6)),
                      )),
                  ListTile(
                      onTap: () {
                        launch(AppDetails.piyushTG);
                      },
                      leading: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          'assets/piyush.jpg',
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: Icon(
                        Typicons.right_open,
                        color: isAmoled
                            ? Uicolor.whiteColor
                            : Get.theme.primaryColor,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'Piyush Varshney',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: isAmoled
                              ? Uicolor.whiteColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'Student >> Designer',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor.withOpacity(0.6)),
                      ))
                ],
              ),
              Container(
                  child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Copyright Notice©',
                          style: MyTextStyle.bodyTextStyle(
                            size: 23,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor,
                          )),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text(AppDetails.copyrightDesc,
                          softWrap: true,
                          style: MyTextStyle.bodyTextStyle(
                            size: 15,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor,
                          )),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text('Made in India ❤️',
                          softWrap: true,
                          style: MyTextStyle.bodyTextStyle(
                            size: 15,
                            color: isAmoled
                                ? Uicolor.whiteColor
                                : Get.theme.primaryColor,
                          )),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
