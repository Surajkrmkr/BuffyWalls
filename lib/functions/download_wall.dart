import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buffywalls_3/functions/notifications.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/snackbar.dart';

class DownloadImage {
  static Future downloadImage(
      BuildContext context, String url, String name, String unique) async {
    await getPermission(context);
    String? directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    String downloadPath = '$directory/$name $unique.jpg';
    int id = Random().nextInt(5000);
    try {
      Future.delayed(Duration.zero).then((_) {
        MySnackBar.wallSnackBar(
            context, "Downloading Started Check Notifcation");
        MyNotifications().downloadNotification(
          id: id,
          titleString: "Downloading",
          messageString: name,
          context: context,
          path: downloadPath,
          isLocked: true,
          layout: NotificationLayout.Default,
        );
      });
      await Dio().download(
        url,
        downloadPath,
      );
    } catch (e) {
      Future.delayed(Duration.zero).then((_) {
        MySnackBar.wallSnackBar(
            context, "Downloading failed try again later $e");
      });
    } finally {
      MyNotifications().downloadNotification(
          id: id,
          titleString: "Downloaded",
          messageString: name,
          context: context,
          path: downloadPath,
          isLocked: false,
          layout: NotificationLayout.Default);
    }
  }

  static getPermission(BuildContext context) async {
    if (await Permission.storage.isDenied) {
      // MySnackBar.snackBar(context, "Please grant storage permission");
      Permission.storage.request();
    } else if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
