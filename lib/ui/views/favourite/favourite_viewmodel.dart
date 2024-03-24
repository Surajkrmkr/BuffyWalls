import 'dart:convert';

import 'package:collection/collection.dart';
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
  // final HomeViewModel _homeViewModel = locator<HomeViewModel>();

  List<List<PopularWall>> walls = [];
  int currentPage = 0;
  List<PopularWall> pageWiseWalls = [];
  List<PopularWall> allWalls = [];
  List<String> wallIds = [];

  final logger = getLogger('FavouriteViewModel');
  final ScrollController controller = ScrollController();

  void setWalls() {
    if (allWalls.isNotEmpty) {
      walls = allWalls.slices(20).toList();
      pageWiseWalls = walls[currentPage];
    }
  }

  Future<void> loadMore() async {
    if (currentPage >= walls.length - 1) return;
    setBusy(true);
    currentPage++;
    await Future.delayed(const Duration(seconds: 1), () {
      pageWiseWalls = [...pageWiseWalls, ...walls[currentPage]];
      setBusy(false);
    });
  }

  void getFavourites() {
    final walls = jsonDecode(_sharedPrefService.getFavourites() as String);
    final List<PopularWall> wallList = walls != null
        ? List<PopularWall>.from(
            ((walls)["data"] as List).map((e) => PopularWall.fromJson(e)),
          )
        : [];
    allWalls = wallList;
    wallIds = wallList.map((e) => e.imageUrl).toList();
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
      showToast(AppStrings.addTofavMsg);
      setFavourites();
    }
  }

  void removeFavourite(String url) {
    allWalls.removeWhere((element) => element.imageUrl == url);
    wallIds.remove(url);
    showToast(AppStrings.removeFromfavMsg);
    setFavourites();
  }

  bool isFavourite(String url) {
    return wallIds.contains(url);
  }

  Future<void> init() async {
    setWalls();
    addScrollListener();
  }

  void addScrollListener() {
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          logger.i('At the top');
        } else {
          logger.i('At the bottom');
          loadMore();
        }
      }
    });
  }
}
