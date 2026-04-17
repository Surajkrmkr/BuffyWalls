import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';

int adsOnClickCount = 1;

class ImageViewModel extends BaseViewModel {
  final logger = getLogger('ImageViewModel');
  final _adService = locator<AdsService>();

  List<Color> colorSwatches = [];
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
  }

  void downloadWallpaper(String url, String name) async {
    if (!BuffyService.isPro) {
      showToast(AppStrings.downloadStartedAfterAd);
      if (adsOnClickCount % 5 == 0) {
        _adService.showInterstitialAd();
      }
      adsOnClickCount++;
      _downloadWallpaper(url, name);
      return;
    }
    _downloadWallpaper(url, name);
  }

  void _downloadWallpaper(String url, String name) async {
    showToast(AppStrings.downloadStarted);
    wallpaperDownloadingState = true;
    try {
      final path = await getDownloadPath();
      await Dio().download(url, '$path/$name.png');
      isWallDownloaded = true;
      showToast(AppStrings.downloadSuccess);
    } catch (error) {
      showToast(AppStrings.downloadFailed);
    } finally {
      wallpaperDownloadingState = false;
    }
  }

  void applyWallpaper(WallApplyAction action, String url) async {
    if (!BuffyService.isPro) {
      showToast(AppStrings.applyStartedAfterAd);
      if (adsOnClickCount % 5 == 0) {
        _adService.showInterstitialAd();
      }
      adsOnClickCount++;
      _applyWallpaper(action, url);
      return;
    }
    _applyWallpaper(action, url);
  }

  void _applyWallpaper(WallApplyAction action, String url) async {
    final WallpaperResult result;
    if (action == WallApplyAction.native) {
      result = await AsyncWallpaper.setWallpaper(WallpaperRequest(
        target: WallpaperTarget.both,
        sourceType: WallpaperSourceType.url,
        source: url,
        goToHome: true,
      ));
    } else {
      final file = await DefaultCacheManager().getSingleFile(url);
      final target = action == WallApplyAction.homescreen
          ? WallpaperTarget.home
          : action == WallApplyAction.lockscreen
              ? WallpaperTarget.lock
              : WallpaperTarget.both;
      result = await AsyncWallpaper.setWallpaper(WallpaperRequest(
        target: target,
        sourceType: WallpaperSourceType.file,
        source: file.path,
        goToHome: true,
      ));
    }
    showToast(result.isSuccess ? AppStrings.successApply : AppStrings.failedApply);
  }

  Future<String> getDownloadPath() async {
    final String downloadDir = await AndroidPathProvider.downloadsPath;
    final Directory? appStorageDir = await getExternalStorageDirectory();
    final path = appStorageDir != null
        ? appStorageDir.path.replaceFirst("data", "media")
        : downloadDir;
    return path;
  }

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
