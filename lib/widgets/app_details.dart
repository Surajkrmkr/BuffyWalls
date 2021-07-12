import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

class AppDetails extends GetxController {
  static String packageName = 'com.shadowteam.buffywallsfree';
  static String proPackageName = 'com.shadowteam.buffywallspaid';
  static String appUrl =
      'https://play.google.com/store/apps/details?id=com.shadowteam.buffywallsfree';
  static String proAppUrl =
      'https://play.google.com/store/apps/details?id=com.shadowteam.buffywallspaid';
  static String devPage =
      'https://play.google.com/store/apps/dev?id=5668598285863173548';

  static String copyrightDesc =
      "All the wallpapers available in BuffyWalls are either open source or licensed under the Creative Commons Zero(CC0) license.if any wallpaper violets copyright rules please report it we will remove it from our application";

  //TG
  static String surajTG = "https://t.me/SurajKrmkr";
  static String piyushTG = "https://t.me/PiyusKPV";
  static String grpTG = "https://t.me/ShadowCreations";

  // Shadow team handle
  static String mailID = "mailto: teamshadowsupp@gmail.com";
  static String fbHandle =
      "https://www.facebook.com/Team-Shadow-102236608184061";
  static String twitterHandle = "https://twitter.com/TeamShadow_Devs?s=09";
  static String instaHandle = "http://instagram.com/devs_team_shadow";

  var version = '1.0.0'.obs;

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }
}
