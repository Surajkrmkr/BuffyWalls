import 'dart:convert';

import 'package:flutter/services.dart';

import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../models/model_export.dart';
import 'json_cache_service.dart';

class ApiService {
  final logger = getLogger('ApiService');
  final _jsonCache = JsonCacheService();
  BuffyWallsModel? model;

  // New keys, so a copy saved before the move to Firebase isn't served for up
  // to a week.
  static const _onboardKey = 'onboardBannersCacheV2';
  static const _onboardAtKey = 'onboardBannersCachedAtV2';

  /// The onboarding wall only refreshes from the server once a week.
  static const _onboardMaxAge = Duration(days: 7);

  /// Wallpaper catalogue. The last good response is kept on disk and used
  /// when the server errors or rate-limits, so a failed fetch never empties
  /// the app for someone who has loaded it before.
  Future<BuffyWallsModel> getWalls() async {
    final url = dotenv.env['URL'] as String;
    try {
      final walls = await _jsonCache.load<BuffyWallsModel>(
        url: url,
        name: 'buffy',
        parse: (body) => BuffyWallsModel.fromJson(jsonDecode(body)),
      );
      if (walls != null) {
        model = walls;
        return walls;
      } else {
        return BuffyWallsModel()..error = "Something went wrong";
      }
    } catch (error) {
      logger.e(error.toString());
      return BuffyWallsModel()..error = "Something went wrong";
    }
  }

  Future<List<String>> _fallbackBanners() async {
    final raw = await rootBundle.loadString('assets/app/onboard_banners.json');
    final data = jsonDecode(raw)["banners"] as List;
    return data.map((e) => e as String).toList();
  }

  List<String>? _cachedOnboard(SharedPreferences prefs) {
    final raw = prefs.getString(_onboardKey);
    if (raw == null) return null;
    try {
      final list = (jsonDecode(raw) as List).map((e) => e as String).toList();
      return list.isEmpty ? null : list;
    } catch (_) {
      return null;
    }
  }

  /// Onboarding wall images. Served from the local copy for up to a week;
  /// only after that does it ask the server again. If the server fails the
  /// older copy (or the bundled list) is used instead.
  Future<List<String>> getOnboardBanners() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = _cachedOnboard(prefs);
    final at = prefs.getInt(_onboardAtKey);
    if (cached != null && at != null) {
      final age = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(at));
      if (age < _onboardMaxAge) return cached;
    }

    try {
      final list = await _jsonCache.load<List<String>>(
        url: dotenv.env['ONBOARD_URL'] as String,
        name: 'startup',
        parse: (body) => (jsonDecode(body)["banners"] as List)
            .map((e) => e as String)
            .toList(),
      );
      if (list != null && list.isNotEmpty) {
        await prefs.setString(_onboardKey, jsonEncode(list));
        await prefs.setInt(_onboardAtKey, DateTime.now().millisecondsSinceEpoch);
        return list;
      }
      logger.w('ApiService | getOnboardBanners - unexpected response');
    } catch (error) {
      logger.w('ApiService | getOnboardBanners - $error');
    }
    return cached ?? await _fallbackBanners();
  }
}
