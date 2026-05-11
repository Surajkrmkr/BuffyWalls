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
}
