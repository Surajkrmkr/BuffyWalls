import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

getSnackbar(String title, String message) {
  Get.snackbar(title, message,
      titleText: Text(
        title,
        style: MyTextStyle.bodyTextStyle(size: 18),
      ),
      messageText: Text(
        message,
        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      ),
      backgroundColor: isAmoled
          ? Uicolor.whiteColor.withOpacity(0.3)
          : Get.theme.backgroundColor,
      colorText: isAmoled ? Uicolor.blackColor : Get.theme.primaryColor,
      margin: EdgeInsets.only(top: 30, left: 20, right: 20));
}
