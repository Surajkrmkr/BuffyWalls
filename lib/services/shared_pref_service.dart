import 'dart:convert';

import '../app/app.package.export.dart';

class SharedPrefService {
  late SharedPreferences prefs;
  final String favouriteWalls = "favouriteWalls";
  final String isInitialised = "isInitialised";
  final String _dialogAdKey = "dialogAdData";

  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setInitialised() {
    prefs.setBool(isInitialised, true);
  }

  bool getInitialised() {
    return prefs.getBool(isInitialised) ?? false;
  }

  Object? getFavourites() {
    return prefs.get(favouriteWalls);
  }

  void setFavourites(Map<String, List> value) {
    prefs.setString(favouriteWalls, jsonEncode(value));
  }

  bool canShowDialogAd() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = prefs.getString(_dialogAdKey);
    if (data == null) return true;
    final map = jsonDecode(data) as Map<String, dynamic>;
    if (map['date'] != today) return true;
    return (map['count'] as int) < 2;
  }

  void recordDialogAdShown() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = prefs.getString(_dialogAdKey);
    int count = 1;
    if (data != null) {
      final map = jsonDecode(data) as Map<String, dynamic>;
      if (map['date'] == today) count = (map['count'] as int) + 1;
    }
    prefs.setString(_dialogAdKey, jsonEncode({'date': today, 'count': count}));
  }

  // Generic local id-list persistence, used for recently viewed / downloaded
  // / applied wallpaper ids so discovery signals survive app restarts
  // without requiring login or a backend.
  List<int> getIdList(String key) {
    return (prefs.getStringList(key) ?? [])
        .map((e) => int.tryParse(e))
        .whereType<int>()
        .toList();
  }

  void setIdList(String key, List<int> ids) {
    prefs.setStringList(key, ids.map((e) => e.toString()).toList());
  }

  static const String recentSearchesKey = "recentSearches";

  List<String> getRecentSearches() {
    return prefs.getStringList(recentSearchesKey) ?? [];
  }

  void setRecentSearches(List<String> searches) {
    prefs.setStringList(recentSearchesKey, searches);
  }

  // Generic "resets every calendar day" persistence, same {'date', ...}
  // shape as the existing dialog-ad cap above. Used by MonetizationService
  // for today's unlocked-premium-wallpaper ids and today's rewarded-video
  // count, without needing a backend or a login.
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  Set<int> getTodayIdSet(String key) {
    final data = prefs.getString(key);
    if (data == null) return {};
    final map = jsonDecode(data) as Map<String, dynamic>;
    if (map['date'] != _today()) return {};
    return (map['ids'] as List<dynamic>).cast<int>().toSet();
  }

  void setTodayIdSet(String key, Set<int> ids) {
    prefs.setString(key, jsonEncode({'date': _today(), 'ids': ids.toList()}));
  }

  int getTodayCount(String key) {
    final data = prefs.getString(key);
    if (data == null) return 0;
    final map = jsonDecode(data) as Map<String, dynamic>;
    if (map['date'] != _today()) return 0;
    return map['count'] as int;
  }

  void setTodayCount(String key, int count) {
    prefs.setString(key, jsonEncode({'date': _today(), 'count': count}));
  }
}
