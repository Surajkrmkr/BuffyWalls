import 'dart:convert';
import 'package:buffywalls/app/app.export.dart';

import 'service_export.dart';

/// Local, per-device monetization state — mirrors the static-utility shape
/// of [BuffyService] (no backend, no login). Tracks which premium
/// wallpapers have been unlocked today via a rewarded video, how many
/// rewarded videos were watched today, and a lightweight session pacer for
/// interstitials.
///
/// Product decision: unlocking is uncapped. Every rewarded video watched
/// instantly and permanently (for today) unlocks that specific wallpaper.
/// The "3" in the Daily Reward Banner is a gamified milestone display, not
/// a hard limit — watching a 4th, 5th, ... video still unlocks wallpapers.
class MonetizationService {
  static const String _unlockedTimestampsKey = "unlockedTimestampsMap";
  static const String _videosWatchedKey = "videosWatchedToday";

  /// Milestone the Daily Reward Banner counts up to before swapping to an
  /// editorial card. Purely cosmetic — see class doc.
  static const int milestoneTarget = 3;

  static final Map<int, DateTime> unlockedPremiumIds = {};
  static int videosWatchedToday = 0;
  static bool _hydrated = false;

  static void hydrate() {
    if (_hydrated) return;
    _hydrated = true;
    final prefsService = locator<SharedPrefService>();
    final data = prefsService.prefs.getString(_unlockedTimestampsKey);
    unlockedPremiumIds.clear();
    if (data != null) {
      try {
        final Map<String, dynamic> map = jsonDecode(data);
        final now = DateTime.now();
        map.forEach((key, value) {
          final id = int.tryParse(key);
          final time = DateTime.tryParse(value.toString());
          if (id != null && time != null) {
            // Keep only if less than 24 hours have passed
            if (now.difference(time).inHours < 24) {
              unlockedPremiumIds[id] = time;
            }
          }
        });
      } catch (_) {}
    }
    videosWatchedToday = prefsService.getTodayCount(_videosWatchedKey);
  }

  static bool isUnlockedToday(int wallId) {
    hydrate();
    final time = unlockedPremiumIds[wallId];
    if (time == null) return false;
    if (DateTime.now().difference(time).inHours >= 24) {
      unlockedPremiumIds.remove(wallId);
      _saveUnlocks();
      return false;
    }
    return true;
  }

  static void unlockToday(int wallId) {
    hydrate();
    unlockedPremiumIds[wallId] = DateTime.now();
    _saveUnlocks();
  }

  static void _saveUnlocks() {
    final prefsService = locator<SharedPrefService>();
    final Map<String, String> map = {};
    unlockedPremiumIds.forEach((key, value) {
      map[key.toString()] = value.toIso8601String();
    });
    prefsService.prefs.setString(_unlockedTimestampsKey, jsonEncode(map));
  }

  /// Call whenever a rewarded video actually completes (reward earned),
  /// regardless of which flow triggered it.
  static void recordVideoWatched() {
    videosWatchedToday++;
    locator<SharedPrefService>().setTodayCount(_videosWatchedKey, videosWatchedToday);
  }

  /// 0..[milestoneTarget] progress for the Daily Reward Banner.
  static int get milestoneProgress {
    hydrate();
    final count = videosWatchedToday > unlockedPremiumIds.length
        ? videosWatchedToday
        : unlockedPremiumIds.length;
    return count > milestoneTarget ? milestoneTarget : count;
  }

  static bool get milestoneReached {
    hydrate();
    final count = videosWatchedToday > unlockedPremiumIds.length
        ? videosWatchedToday
        : unlockedPremiumIds.length;
    return count >= milestoneTarget;
  }

  // --- Session interstitial pacer -----------------------------------
  // Callers decide *when* it's safe to actually show an interstitial
  // (never during Apply/Download/Favorite/Share); this just tracks "has
  // enough meaningful navigation happened since the last one".
  static int _detailViewsSinceLastInterstitial = 0;
  static const int _detailViewsPerInterstitial = 4;

  static void notifyDetailViewed() {
    _detailViewsSinceLastInterstitial++;
  }

  static bool get isInterstitialDue =>
      _detailViewsSinceLastInterstitial >= _detailViewsPerInterstitial;

  static void resetInterstitialPacer() {
    _detailViewsSinceLastInterstitial = 0;
  }
}
