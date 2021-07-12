

import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:is_pirated/is_pirated.dart';
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';

statusCheck(NewVersion? newVersion) async {
    await Future.delayed(Duration(seconds: 3));
    final status = await newVersion!.getVersionStatus();
    await Future.delayed(Duration(seconds: 3));
    if(status!.canUpdate ){
      Get.defaultDialog(
        barrierDismissible: false,
        title: 'Update Available : '+status.storeVersion,
        titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            status.releaseNotes!,
            style: MyTextStyle.bodyTextStyleWithDefaultSize(),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Later',
              style: MyTextStyle.bodyTextStyle(
                  size: 14, color: defaultAccentColor),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(defaultAccentColor)),
              onPressed: () {
                ProDialog.appIsPro ?
                launch(AppDetails.proAppUrl):
                launch(AppDetails.appUrl);
              },
              child:
                  Text('Update', style: MyTextStyle.bodyTextStyleWithDefaultSize()))
        ]);
    }
  }


Future<void> checkPiracy(isPirated) async {
    try {
      isPirated = await getIsPirated(
        debugOverride: false,
        // openStoreListing: true,
        // playStoreIdentifier: ProDialog.appIsPro ? AppDetails.proPackageName:AppDetails.packageName,
        // closeApp: true,
        );
      print(isPirated.status);
      if(isPirated.status!){
        Get.defaultDialog(
         onWillPop: () async => false,
         barrierDismissible: false,
        title: 'Something went wrong',
        middleText: 'Please reinstall the app from playstore',
        titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        middleTextStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        actions: [
          OutlinedButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text(
              'Close',
              style: MyTextStyle.bodyTextStyle(
                  size: 14, color: defaultAccentColor),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(defaultAccentColor)),
              onPressed: () {
                ProDialog.appIsPro ?
                launch(AppDetails.proAppUrl):
                launch(AppDetails.appUrl);
              },
              child:
                  Text('Reinstall', style: MyTextStyle.bodyTextStyleWithDefaultSize()))
        ]);
      }
    } on PlatformException {}
  }