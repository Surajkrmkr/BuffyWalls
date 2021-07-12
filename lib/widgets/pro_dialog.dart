import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProDialog {
  static bool appIsPro = true;

  static List<String> proImages = [
    "assets/pro.jpg",
    "assets/accent.jpg",
    "assets/amoled.jpg"
  ];

  static List<String> proTip = [
    "Access to everything",
    "Accent Colour can be changed",
    "Amoled Mode Unlocked",
  ];

  List<Widget> pages = [
    Column(
      children: [
        Text(
          proTip[0],
          style: MyTextStyle.bodyTextStyleWithDefaultSize(),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(proImages[0])),
        )),
      ],
    ),
    Column(
      children: [
        Text(
          proTip[1],
          style: MyTextStyle.bodyTextStyleWithDefaultSize(),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(proImages[1])),
        )),
      ],
    ),
    Column(
      children: [
        Text(
          proTip[2],
          style: MyTextStyle.bodyTextStyleWithDefaultSize(),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(proImages[2])),
        )),
      ],
    ),
  ];

  getProDialog() => Get.defaultDialog(
          title: 'Go Pro',
          titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
          backgroundColor:
              isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
          content: Container(
            height: 250,
            width: 250,
            child: PageView(
              children: pages,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                launch(AppDetails.proAppUrl);
              },
              child: Text(
                'Buy Now',
                style: MyTextStyle.bodyTextStyle(
                    size: 14, color: defaultAccentColor),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(defaultAccentColor)),
                onPressed: () {
                  Get.back();
                },
                child: Text('Later',
                    style: MyTextStyle.bodyTextStyleWithDefaultSize()))
          ]);
}
