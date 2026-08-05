import 'dart:io';
import 'dart:math';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class ImageViewModel extends BaseViewModel {
  final logger = getLogger('ImageViewModel');
  final _adService = locator<AdsService>();

  List<Color> colorSwatches = [];

  void copyColorCode(Color color) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    final hexCode = '#${hex.substring(2)}';
    Clipboard.setData(ClipboardData(text: hexCode));
    showToast("Copied $hexCode to clipboard");
  }
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

  void logScreenView(String wallName) {
    AnalyticsService.instance.logImageScreen(wallName);
  }

  // Interstitials must never interrupt Apply/Download/Favorite/Share —
  // see [MonetizationService] for the session-paced "after meaningful
  // navigation" trigger used instead (wired on exit, in image_view.dart).
  void downloadWallpaper(String url, String name, int wallId) async {
    AnalyticsService.instance.logWallpaperDownloaded(name);
    BuffyService.addDownloaded(wallId);
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

  void applyWallpaper(WallApplyAction action, String url, int wallId) async {
    AnalyticsService.instance.logWallpaperApplied(url, action.name);
    BuffyService.addApplied(wallId);
    _applyWallpaper(action, url);
  }

  void _applyWallpaper(WallApplyAction action, String url) async {
    WallpaperResult result;
    try {
      final target = action == WallApplyAction.homescreen
          ? WallpaperTarget.home
          : action == WallApplyAction.lockscreen
              ? WallpaperTarget.lock
              : WallpaperTarget.both;

      if (action == WallApplyAction.native) {
        result = await AsyncWallpaper.openWallpaperChooser();
      } else {
        result = await AsyncWallpaper.setWallpaper(
          WallpaperRequest(
            target: target,
            sourceType: WallpaperSourceType.url,
            source: url,
            goToHome: true,
          ),
        );
      }
    } catch (e) {
      logger.e("Error setting wallpaper: $e");
      result = WallpaperResult.failure(
        WallpaperError(
          code: WallpaperErrorCode.unknown,
          message: e.toString(),
        ),
      );
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

  void loadInterstitialAd() {
    if (BuffyService.isPro) return;
    _adService.loadInterstitialAd();
    MonetizationService.notifyDetailViewed();
  }

  /// Called right as the user backs out of this detail page — the
  /// "meaningful navigation" checkpoint from the spec (never during
  /// Apply/Download/Favorite/Share, only on exit, and only every few
  /// wallpapers per [MonetizationService.isInterstitialDue]).
  void maybeShowExitInterstitial() {
    if (BuffyService.isPro) return;
    if (MonetizationService.isInterstitialDue) {
      MonetizationService.resetInterstitialPacer();
      _adService.showInterstitialAd();
    }
  }

  Color? selectedColorFilter;

  // Cached "You May Also Like" results. `toggleInfoUI`/ad/download state
  // changes call `rebuildUi()` far more often than the underlying related
  // set actually changes, and each recompute walks the full wallpaper
  // list — so these are computed once (on load / on color-filter change)
  // rather than inline in the widget build.
  List<PopularWall> relatedWalls = [];
  List<PopularWall> relatedByColor = [];

  List<PopularWall> freeAlternatives = [];

  void loadRelated(PopularWall currentWall) {
    relatedWalls = getRelatedWallpapers(currentWall);
    final homeModel = locator<HomeViewModel>();
    final allWalls = homeModel.originalWallList;
    freeAlternatives = allWalls.where((w) {
      if (w.isPremium || w.id == currentWall.id) return false;
      return w.category == currentWall.category ||
          w.tags.any((t) => currentWall.tags.contains(t));
    }).toList();
    if (freeAlternatives.length < 10) {
      final fallbackFree = allWalls
          .where((w) =>
              !w.isPremium &&
              w.id != currentWall.id &&
              !freeAlternatives.contains(w))
          .toList();
      freeAlternatives.addAll(fallbackFree);
    }
  }

  Future<bool> checkProRequirement(BuildContext context, PopularWall wall) async {
    final unlockedToday =
        wall.isPremium && MonetizationService.isUnlockedToday(wall.id);
    if (!BuffyService.isPro && wall.isPremium && !unlockedToday) {
      final response = await locator<DialogService>().showCustomDialog(
        variant: DialogType.pro,
        barrierDismissible: false,
        data: {'wallId': wall.id},
      );
      return response?.confirmed == true;
    }
    return true;
  }

  void selectColorFilter(Color color) {
    if (selectedColorFilter == color) {
      selectedColorFilter = null; // Toggle off if clicked again
    } else {
      selectedColorFilter = color;
      relatedByColor = getRelatedByColor(color);
    }
    rebuildUi();
  }

  List<PopularWall> getRelatedByColor(Color targetColor) {
    final homeModel = locator<HomeViewModel>();
    return homeModel.originalWallList.where((wall) {
      return wall.colors.any((c) => c.toARGB32() == targetColor.toARGB32());
    }).toList();
  }

  /// "Infinite Discovery" carousel — same category / same colors / same
  /// tags via the shared [RecommendationEngine], topped up with hot,
  /// latest, and seeded-random picks so it's always full. Never lets the
  /// user hit the end of content.
  List<PopularWall> getRelatedWallpapers(PopularWall currentWall) {
    final homeModel = locator<HomeViewModel>();
    final allWalls = homeModel.originalWallList;
    if (allWalls.isEmpty) return [];

    return RecommendationEngine.recommend(
      pool: allWalls,
      excludeIds: {currentWall.id},
      categories: {currentWall.category},
      tags: currentWall.tags.toSet(),
      colorValues: currentWall.colors.map((c) => c.toARGB32()).toSet(),
      premiumLean: currentWall.isPremium,
      limit: 12,
      randomSeed: currentWall.id,
    );
  }
}

enum WallApplyAction { homescreen, lockscreen, both, native }
