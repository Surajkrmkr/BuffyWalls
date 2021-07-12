import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Get.defaultDialog(
        title: 'No Internet Connection',
        middleText: 'Please connect to a network',
        titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        middleTextStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(defaultAccentColor)),
            onPressed: () {
              if (connectivityResult != ConnectivityResult.none) {
                Get.back();
              } else {
                Get.back();
                checkConnectivity();
              }
            },
            child: Text('Retry',
                style: TextStyle(
                  fontFamily: 'Body',
                  color: Colors.white,
                )),
          ),
        ]);
  }
}
