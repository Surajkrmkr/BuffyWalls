import 'package:share_plus/share_plus.dart';

import 'app_details.dart';

class MyShare {
  static shareImage(String url) async {
    try {
      Share.share(
        'Check out This Awesome Wallpaper \n$url\n Download This Cool App Link : ${AppDetails.appUrl}',
        subject: 'Hii Check Out this Awesome Wallpaper App',
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static shareApp() async {
    try {
      Share.share(
        'Share this Awesome Wallpaper App to Your Friends\n Link : ${AppDetails.appUrl}',
        subject:
            'Check out This Awesome Wallpaper App ',
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
