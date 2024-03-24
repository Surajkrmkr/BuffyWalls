import 'dart:convert';

import '../app/app.package.export.dart';

class SharedPrefService {
  late SharedPreferences prefs;
  final String favouriteWalls = "favouriteWalls";

  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  Object? getFavourites() {
    return prefs.get(favouriteWalls);
  }

  void setFavourites(Map<String, List> value) {
    prefs.setString(favouriteWalls, jsonEncode(value));
  }
}
