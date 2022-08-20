import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';

class ProDialog {
  static const bool appIsPro = true;

  static final List<String> proImages = [
    "assets/Pro Dialog/Pro.png",
    "assets/Pro Dialog/Ads.png",
    "assets/Pro Dialog/Amoled.png",
    "assets/Pro Dialog/Fav.png"
  ];

  static final List<String> proTip = [
    "Access to everything",
    "No ADs",
    "Amoled mode unlocked",
    "Favourite option access"
  ];

  List<Widget> pages(BuildContext context) => [
    Column(
      children: [
        Text(
          proTip[0],
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
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
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
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
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
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
    Column(
      children: [
        Text(
          proTip[3],
          style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(proImages[3])),
        )),
      ],
    ),
  ];

  // TODO : add pro dialog
  // getProDialog() => Get.defaultDialog(
  //         title: 'Go Pro Now',
  //         titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
  //         backgroundColor:
  //             isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
  //         content: SizedBox(
  //           height: 250,
  //           width: 250,
  //           child: PageView(
  //             physics: const BouncingScrollPhysics(
  //                 parent: AlwaysScrollableScrollPhysics()),
  //             children: pages,
  //           ),
  //         ),
  //         actions: [
  //           OutlinedButton(
  //             onPressed: () {
  //               launch(AppDetails.proAppUrl);
  //             },
  //             child: Text(
  //               'Buy Now',
  //               style: MyTextStyle.bodyTextStyle(
  //                   size: 14, color: defaultAccentColor),
  //             ),
  //           ),
  //           ElevatedButton(
  //               style: ButtonStyle(
  //                   backgroundColor:
  //                       MaterialStateProperty.all(defaultAccentColor)),
  //               onPressed: () {
  //                 Get.back();
  //               },
  //               child: Text('Later',
  //                   style: MyTextStyle.bodyTextStyleWithDefaultSize()))
  //         ]);
}
