import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';

@lazySingleton
class FavouriteViewModel extends BaseViewModel {
  final SharedPrefService _sharedPrefService = locator<SharedPrefService>();

  List<PopularWall> allWalls = [];
  List<String> wallIds = [];

  final logger = getLogger('FavouriteViewModel');
  final ScrollController controller = ScrollController();

  void getFavourites() {
    final favObj = _sharedPrefService.getFavourites();
    if (favObj != null) {
      final walls = jsonDecode(favObj as String);
      final List<PopularWall> wallList = walls != null
          ? List<PopularWall>.from(
              ((walls)["data"] as List).map((e) => PopularWall.fromJson(e)),
            )
          : [];
      allWalls = wallList;
      wallIds = wallList.map((e) => e.imageUrl).toList();
    }
  }

  void setFavourites() {
    rebuildUi();
    _sharedPrefService
        .setFavourites({"data": allWalls.map((e) => e.toJson()).toList()});
  }

  void addFavourite(PopularWall? wall) {
    if (wall != null) {
      allWalls.add(wall);
      wallIds.add(wall.imageUrl);
      AnalyticsService.instance.logAddToFavourites(wall.name);
      showToast(AppStrings.addTofavMsg);
      setFavourites();
    }
  }

  void removeFavourite(String url) {
    final wall = allWalls.firstWhere((e) => e.imageUrl == url,
        orElse: () => PopularWall());
    AnalyticsService.instance.logRemoveFromFavourites(wall.name);
    allWalls.removeWhere((element) => element.imageUrl == url);
    wallIds.removeWhere((e) => e == url);
    showToast(AppStrings.removeFromfavMsg);
    setFavourites();
  }

  bool isFavourite(String url) {
    return wallIds.contains(url);
  }
}
