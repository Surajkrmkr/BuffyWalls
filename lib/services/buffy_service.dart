import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:buffywalls/app/app.export.dart';

import '../app/app.package.export.dart';
import '../models/model_export.dart';
import '../ui/common/common_export.dart';
import '../ui/widgets/widget_export.dart';
import 'service_export.dart';

class BuffyService {
  static bool isPro =
      (dotenv.env['BUFFY'] as String == dotenv.env["PAID"] as String);

  static bool isInitialized = locator<SharedPrefService>().getInitialised();

  static const String _viewedKey = "recentlyViewedIds";
  static const String _downloadedKey = "recentlyDownloadedIds";
  static const String _appliedKey = "recentlyAppliedIds";

  static final List<PopularWall> sessionHistory = [];
  static final Set<int> downloadedIds = {};
  static final Set<int> appliedIds = {};
  static bool _hydrated = false;

  /// Restores locally-persisted discovery signals (recently viewed,
  /// downloaded, applied) so Continue Browsing and the recommendation
  /// engine keep working across app restarts without requiring login.
  static void hydrate(List<PopularWall> allWalls) {
    if (_hydrated) return;
    _hydrated = true;
    final prefs = locator<SharedPrefService>();

    final viewedIds = prefs.getIdList(_viewedKey);
    sessionHistory
      ..clear()
      ..addAll(viewedIds
          .map((id) => allWalls.firstWhereOrNull((w) => w.id == id))
          .whereType<PopularWall>());

    downloadedIds
      ..clear()
      ..addAll(prefs.getIdList(_downloadedKey));
    appliedIds
      ..clear()
      ..addAll(prefs.getIdList(_appliedKey));
  }

  static void addToHistory(PopularWall wall) {
    sessionHistory.removeWhere((w) => w.id == wall.id);
    sessionHistory.insert(0, wall);
    if (sessionHistory.length > 10) {
      sessionHistory.removeLast();
    }
    locator<SharedPrefService>()
        .setIdList(_viewedKey, sessionHistory.map((w) => w.id).toList());
  }

  static void addDownloaded(int id) {
    if (downloadedIds.add(id)) {
      locator<SharedPrefService>()
          .setIdList(_downloadedKey, downloadedIds.toList());
    }
  }

  static void addApplied(int id) {
    if (appliedIds.add(id)) {
      locator<SharedPrefService>()
          .setIdList(_appliedKey, appliedIds.toList());
    }
  }

  static const String _interactionCountKey = "userInteractionCount";
  static const String _ratePopupShownKey = "ratePopupShown";
  static const String _installTimestampKey = "installTimestampMillis";
  static const String _firstLaunchPopupShownKey = "firstLaunchRatePopupShown";
  static const Duration _ratePopupMinAge = Duration(hours: 24);

  /// First moment `BuffyService` ever ran on this device — stamped once,
  /// read forever after. Backs the "don't show the 2-interaction rate
  /// popup until 24h post-install" rule.
  static DateTime _installTimestamp() {
    final prefs = locator<SharedPrefService>().prefs;
    final millis = prefs.getInt(_installTimestampKey);
    if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
    final now = DateTime.now();
    prefs.setInt(_installTimestampKey, now.millisecondsSinceEpoch);
    return now;
  }

  /// The one-time, first-ever-open prompt: rate 5 stars and get to pick a
  /// Pro wallpaper to unlock for free, no strings attached. Fires 2
  /// minutes into the session rather than immediately, so it doesn't
  /// ambush the user before they've even seen the app. Distinct from
  /// [recordInteraction]'s later, no-reward nudge. Safe to call from a
  /// widget's `build()` on every rebuild.
  static bool _firstLaunchTimerScheduled = false;
  static void maybeShowFirstLaunchRatePopup(BuildContext context) {
    if (_firstLaunchTimerScheduled) return;
    final prefs = locator<SharedPrefService>().prefs;
    if (prefs.getBool(_firstLaunchPopupShownKey) ?? false) {
      _firstLaunchTimerScheduled = true;
      return;
    }
    _firstLaunchTimerScheduled = true;
    _installTimestamp(); // make sure install time is stamped from launch 1

    // The flag is only persisted once the dialog actually shows — if the
    // app closes before the 2 minutes are up, the next launch schedules
    // another timer instead of silently losing the one-time prompt.
    Future.delayed(const Duration(minutes: 2), () {
      if (!context.mounted) return;
      prefs.setBool(_firstLaunchPopupShownKey, true);
      showRateDialog(context, rewardFirstWallpaper: true);
    });
  }

  /// The later, no-reward nudge: shown once, only after the user has done
  /// 2+ meaningful interactions (download/apply/favourite/...) AND at
  /// least 24 hours have passed since install — so it never competes with
  /// [maybeShowFirstLaunchRatePopup] on a fresh install.
  static void recordInteraction(BuildContext context) {
    final prefsService = locator<SharedPrefService>();
    final shown = prefsService.prefs.getBool(_ratePopupShownKey) ?? false;
    if (shown) return;

    final count = (prefsService.prefs.getInt(_interactionCountKey) ?? 0) + 1;
    prefsService.prefs.setInt(_interactionCountKey, count);

    final oldEnough = DateTime.now().difference(_installTimestamp()) >= _ratePopupMinAge;
    if (count >= 2 && oldEnough) {
      prefsService.prefs.setBool(_ratePopupShownKey, true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showRateDialog(context);
      });
    }
  }

  static void showRateDialog(BuildContext outerContext, {bool rewardFirstWallpaper = false}) {
    showDialog(
      context: outerContext,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.08),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      rewardFirstWallpaper ? Icons.card_giftcard_rounded : Icons.star_rate_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    rewardFirstWallpaper
                        ? "Rate Us & Unlock a Free Pro Wallpaper!"
                        : "Enjoying BuffyWalls?",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rewardFirstWallpaper
                        ? "Give us 5 stars on the Play Store and we'll unlock your first Premium wallpaper for free — instantly, no strings attached."
                        : "If you love finding premium wallpapers, please take a moment to rate us on the Play Store!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Maybe Later",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            launchUrl(
                              Uri.parse(Links.buffyFree),
                              mode: LaunchMode.externalApplication,
                            );
                            if (rewardFirstWallpaper) {
                              // Let the user choose which Pro wallpaper to
                              // unlock, same picker used by the Daily
                              // Reward Banner, instead of auto-picking one.
                              showPremiumWallpaperPicker(
                                outerContext,
                                onSelected: (wall) {
                                  MonetizationService.unlockToday(wall.id);
                                  showToast("🎉 '${wall.name}' unlocked for free!");
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                "Rate 5 Stars",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
