import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DarkModePersistenceService {
  final getStorage = GetStorage();
  final darkKey = "isDarkMode";
  final amoledKey = "isAmoled";
  final accentColorKey = "accent";

  bool savedDarkMode() {
    return getStorage.read(darkKey) ?? false;
  }

  void saveThemeMode(bool val) {
    getStorage.write(darkKey, val);
  }

  bool savedAmoledMode() {
    return getStorage.read(amoledKey) ?? false;
  }

  void saveAmoledMode(bool val) {
    getStorage.write(amoledKey, val);
  }

  int savedAccentColor() {
    return getStorage.read(accentColorKey) ?? const Color(0xFFFE5C6D).value;
  }

  void saveAccentColor(int val) {
    getStorage.write(accentColorKey, val);
  }
}

class RatingNotification {
  final ratingNotifyKey = "ratingNotify";
  final getStorage = GetStorage();

  bool savedRatingNotify() {
    return getStorage.read(ratingNotifyKey) ?? false;
    // return false;
  }

  void saveRatingNotify(bool val) {
    getStorage.write(ratingNotifyKey, val);
  }
}
