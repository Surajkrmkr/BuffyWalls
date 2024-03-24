import 'dart:convert';

import '../app/app.package.export.dart';

class SharedPrefService {
  late SharedPreferences prefs;
  final String favouriteWalls = "favouriteWalls";
  final String isInitialised = "isInitialised";

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
}
