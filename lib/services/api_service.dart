import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../models/model_export.dart';

class ApiService {
  final logger = getLogger('ApiService');
  BuffyWallsModel? model;

  static const _cacheFileName = 'buffy_walls_cache.json';
  static const _onboardKey = 'onboardBannersCache';
  static const _onboardAtKey = 'onboardBannersCachedAt';

  /// The onboarding wall only refreshes from the server once a week.
  static const _onboardMaxAge = Duration(days: 7);

  Future<File> _cacheFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_cacheFileName');
  }

  /// Wallpaper catalogue. The last good response is kept on disk and used
  /// when the server errors or rate-limits (e.g. GitLab 429), so a failed
  /// fetch never empties the app for someone who has loaded it before.
  Future<BuffyWallsModel> getWalls() async {
    final client = Dio();
    final url = dotenv.env['URL'] as String;
    try {
      final response = await client.get(url);
      final body = response.data;
      if (response.statusCode == 200 && body is String && body.trimLeft().startsWith('{')) {
        final parsed = BuffyWallsModel.fromJson(jsonDecode(body));
        model = parsed;
        try {
          await (await _cacheFile()).writeAsString(body);
        } catch (e) {
          logger.w('ApiService | getWalls - could not write cache: $e');
        }
        return parsed;
      }
      logger.w('ApiService | getWalls - unexpected response, trying cache');
    } catch (error) {
      logger.e(error.toString());
    }
    return _wallsFromCache();
  }

  Future<BuffyWallsModel> _wallsFromCache() async {
    try {
      final file = await _cacheFile();
      if (await file.exists()) {
        model = BuffyWallsModel.fromJson(jsonDecode(await file.readAsString()));
        logger.w('ApiService | getWalls - serving cached catalogue');
        return model!;
      }
    } catch (error) {
      logger.e('ApiService | cache read failed: $error');
    }
    return BuffyWallsModel()..error = "Something went wrong";
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
      final response = await Dio().get(dotenv.env['ONBOARD_URL'] as String);
      final body = response.data;
      if (response.statusCode == 200 &&
          body is String &&
          body.trimLeft().startsWith('{')) {
        final list =
            (jsonDecode(body)["banners"] as List).map((e) => e as String).toList();
        if (list.isNotEmpty) {
          await prefs.setString(_onboardKey, jsonEncode(list));
          await prefs.setInt(_onboardAtKey, DateTime.now().millisecondsSinceEpoch);
          return list;
        }
      }
      logger.w('ApiService | getOnboardBanners - unexpected response');
    } catch (error) {
      logger.w('ApiService | getOnboardBanners - $error');
    }
    return cached ?? await _fallbackBanners();
  }
}
