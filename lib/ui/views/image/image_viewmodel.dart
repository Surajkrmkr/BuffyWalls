import 'dart:io';
import 'dart:math';

import 'package:android_download_manager/android_download_manager.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.logger.dart';
import '../../common/common_export.dart';
import '../../widgets/toast.dart';

class ImageViewModel extends BaseViewModel {
  final logger = getLogger('ImageViewModel');

  List<Color> colorSwatches = [];
  int wallDownloadKey = 0;
  String imageSize = "0 MB";
  String imageResolution = "0 x 0";
  bool hideInfoUI = false;
  bool showApplyWallUI = false;
  bool isWallDownloading = false;
  bool isWallDownloaded = false;

  set wallpaperDownloadingState(bool value) {
    isWallDownloading = value;
    rebuildUi();
  }

  void checkIfWallDownloaded(String name) async {
    final path = await getDownloadPath();
    final file = File('$path/$name.png');
    if (file.existsSync()) {
      isWallDownloaded = true;
      rebuildUi();
    }
    AndroidDownloadManager.listen((data) {
      if (int.parse(data["id"]) == wallDownloadKey) {
        wallpaperDownloadingState = false;
        isWallDownloaded = true;
        showToast(AppStrings.downloadSuccess);
        rebuildUi();
      }
    });
  }

  void downloadWallpaper(String url, String name) async {
    showToast(AppStrings.downloadStarted);
    wallpaperDownloadingState = true;
    try {
      final path = await getDownloadPath();
      wallDownloadKey = await AndroidDownloadManager.enqueue(
        downloadUrl: url,
        downloadPath: path,
        fileName: "$name.png",
      );
    } catch (error) {
      showToast(AppStrings.downloadFailed);
      wallpaperDownloadingState = false;
    }
  }

  void applyWallpaper(WallApplyAction action, String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    switch (action) {
      case WallApplyAction.native:
        await AsyncWallpaper.setWallpaperNative(
          url: url,
          goToHome: true,
          errorToastDetails: _getToast(AppStrings.failedApply),
          toastDetails: _getToast(AppStrings.successApply),
        );
        break;
      case WallApplyAction.homescreen:
      case WallApplyAction.lockscreen:
      case WallApplyAction.both:
        await AsyncWallpaper.setWallpaperFromFile(
          filePath: file.path,
          wallpaperLocation: action == WallApplyAction.homescreen
              ? 1
              : action == WallApplyAction.lockscreen
                  ? 2
                  : 3,
          goToHome: true,
          errorToastDetails: _getToast(AppStrings.failedApply),
          toastDetails: _getToast(AppStrings.successApply),
        );
        break;
    }
  }

  Future<String> getDownloadPath() async {
    final String downloadDir = await AndroidPathProvider.downloadsPath;
    final Directory? appStorageDir = await getExternalStorageDirectory();
    final path = appStorageDir != null
        ? appStorageDir.path.replaceFirst("data", "media")
        : downloadDir;
    return path;
  }

  ToastDetails _getToast(String msg) => ToastDetails(
      message: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);

  void toggleInfoUI() {
    hideInfoUI = !hideInfoUI;
    rebuildUi();
  }

  void toggleApplyWallUI() {
    showApplyWallUI = !showApplyWallUI;
    rebuildUi();
  }

  Future<void> getColorPalette(String url) async {
    setBusy(true);
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(url),
      maximumColorCount: 8,
    );
    await Future.delayed(Durations.long4);
    colorSwatches = paletteGenerator.colors.toList();
    setBusy(false);
  }

  Future<void> getImgDetails(String url) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(url);
    final fileBytes = file.readAsBytesSync();
    imageSize = formatBytes(fileBytes.lengthInBytes);

    final decodedImage = await decodeImageFromList(fileBytes);
    imageResolution = "${decodedImage.width} x ${decodedImage.height}";
    rebuildUi();
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}

enum WallApplyAction { homescreen, lockscreen, both, native }
