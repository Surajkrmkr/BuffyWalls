import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperAction extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //To set Walls in Home
  static Future<void> setWall({String? url,int? type}) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(url!);
      await WallpaperManagerFlutter().setwallpaperfromFile(
          file.path, type!);
    } on Exception {
      throw Exception('Error');
    }
  }
}
