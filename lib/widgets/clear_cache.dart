import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

clearCache() => Get.defaultDialog(
        title: 'Clear Cache',
        middleText: 'Are you really want to clear cache ?',
        titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        middleTextStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        actions: [
          OutlinedButton(
            onPressed: () {
              DefaultCacheManager().emptyCache();
              Get.back();
              getSnackbar('Cache', "has been cleared");
            },
            child: Text(
              'Yes',
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
              child:
                  Text('No', style: MyTextStyle.bodyTextStyleWithDefaultSize()))
        ]);
