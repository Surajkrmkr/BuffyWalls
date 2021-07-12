import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:get/get.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

setWallDialog(String url) {
  Get.defaultDialog(
    backgroundColor: isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
    title: 'Set Wallpaper',
    titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
    content: Column(
      children: [
        ListTile(
          title: Text(
            'Homescreen',
            style: MyTextStyle.bodyTextStyleWithDefaultSize(),
          ),
          onTap: () {
            setHomeWall(url);
            Get.back();
          },
        ),
        ListTile(
          title: Text(
            'Lockscreen',
            style: MyTextStyle.bodyTextStyleWithDefaultSize(),
          ),
          onTap: () {
            setLockWall(url);
            Get.back();
          },
        ),
        ListTile(
          title: Text(
            'Both',
            style: MyTextStyle.bodyTextStyleWithDefaultSize(),
          ),
          onTap: () {
            setBothWall(url);
            Get.back();
          },
        )
      ],
    ),
  );
}

//To set Walls in Home
Future<void> setHomeWall(String url) async {
  int location = WallpaperManagerFlutter.HOME_SCREEN;
  var file = await DefaultCacheManager().getSingleFile(url);
  WallpaperManagerFlutter().setwallpaperwithFile(file, location);
  getSnackbar('Wallpaper', 'set successfully');
}

//To set Walls in LOCK
Future<void> setLockWall(String url) async {
  int location = WallpaperManagerFlutter.LOCK_SCREEN;
  var file = await DefaultCacheManager().getSingleFile(url);
  WallpaperManagerFlutter().setwallpaperwithFile(file, location);
  getSnackbar('Wallpaper', 'set successfully');
}

//To set Walls in BOTH
Future<void> setBothWall(String url) async {
  int location = WallpaperManagerFlutter.BOTH_SCREENS;
  var file = await DefaultCacheManager().getSingleFile(url);
  WallpaperManagerFlutter().setwallpaperwithFile(file, location);
  getSnackbar('Wallpaper', 'set successfully');
}
