import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDetails extends ChangeNotifier {
  static const String packageName = 'com.shadowteam.buffywallsfree';
  static const String proPackageName = 'com.shadowteam.buffywallspaid';
  static const String appUrl =
      'https://play.google.com/store/apps/details?id=com.shadowteam.buffywallsfree';
  static const String proAppUrl =
      'https://play.google.com/store/apps/details?id=com.shadowteam.buffywallspaid';
  static const String devPage =
      'https://play.google.com/store/apps/dev?id=5668598285863173548';

  static const String copyrightDesc =
      "All the wallpapers available in BuffyWalls are either open source or licensed under the Creative Commons Zero(CC0) license.if any wallpaper violets copyright rules please report it we will remove it from our application";

  //TG
  static const String surajTG = "https://t.me/SurajKrmkr";
  static const String piyushTG = "https://t.me/PiyusKPV";
  static const String grpTG = "https://t.me/ShadowCreations";

  // Shadow team handle
  static const String mailID = "mailto: teamshadowsupp@gmail.com";
  static const String fbHandle =
      "https://www.facebook.com/Team-Shadow-102236608184061";
  static const String twitterHandle =
      "https://twitter.com/Piyushkpv";
  static const String instaHandle = "https://www.instagram.com/buffywallss/";

  var _version = '1.0.0';
  String get version => _version;
  set version(String value) {
    _version = value;
    notifyListeners();
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  AppDetails() {
    getVersion();
  }
}
