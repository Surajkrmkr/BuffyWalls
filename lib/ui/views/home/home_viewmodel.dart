import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../view_export.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigator = locator<NavigationService>();
  final _categoryModelView = locator<CategoryViewModel>();
  final _favouriteViewModel = locator<FavouriteViewModel>();
  final logger = getLogger('HomeViewModel');

  final ScrollController controller = ScrollController();

  BuffyWallsModel data = BuffyWallsModel();

  List<String> trendingCollection = [];
  List<PopularWall> originalWallList = [];
  List<PopularWall> premiumWallList = [];
  List<PopularWall> trendingCollectionWalls = [];

  Map<String, List<PopularWall>> categories = <String, List<PopularWall>>{};
  Map<String, List<PopularWall>> filterWalls = <String, List<PopularWall>>{};
  Map<Color, List<PopularWall>> colorWalls = <Color, List<PopularWall>>{};
  Tag tag = Tag(selectedTags: [], unSelectedTags: []);

  String selectedFilter = AppStrings.trendingTitle;
  String currentVersion = "1.0.0";

  void onSelectFilter(String value) {
    if (selectedFilter != value) {
      selectedFilter = value;
      rebuildUi();
    }
  }

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  Future<void> getWalls() async {
    setBusy(true);
    _favouriteViewModel.getFavourites();
    final BuffyWallsModel model = await _apiService.getWalls();

    if (model.error.isNotEmpty) {
      logger.e(model.error);
      throw Exception(model.error);
    }
    data = model;
    originalWallList = model.popular;
    trendingCollection = model.hotCollections;
    _extractCategoryAndTags();
    _categoryModelView.setCategory(categories);
    setBusy(false);
  }

  void _extractCategoryAndTags() {
    clearData();
    for (PopularWall wall in originalWallList) {
      if (!categories.containsKey(wall.category)) {
        categories[wall.category] = []; // Initiating a Empty list of a category
      }
      for (Color color in wall.colors) {
        if (!colorWalls.containsKey(color)) {
          colorWalls[color] = []; // Initiating a Empty list of a color
        }
        colorWalls[color]!.add(wall);
      }
      for (String eachTag in wall.tags) {
        if (!tag.unSelectedTags.contains(eachTag)) {
          tag.unSelectedTags.add(eachTag); // Adding a tag to TagList
        }
        if (trendingCollection.contains(eachTag)) {
          trendingCollectionWalls.add(wall);
        }
        if (data.trendingTags.contains(eachTag)) {
          if (!filterWalls.containsKey(eachTag)) {
            filterWalls[eachTag] = [];
          }
          filterWalls[eachTag]!.add(wall);
        }
      }
      categories[wall.category]!.add(wall); // Adding a Wall to CategoryList

      if (wall.isPremium) {
        premiumWallList.add(wall); // Adding a Wall to PremiumList
      }
    }
  }

  void addFavourite(String url) {
    final wall =
        data.popular.firstWhereOrNull((element) => element.imageUrl == url);
    _favouriteViewModel.addFavourite(wall);
  }

  void clearData() {
    categories.clear();
    colorWalls.clear();
    filterWalls.clear();
    tag.selectedTags.clear();
    tag.unSelectedTags.clear();
  }

  void navigateToCommonColorView(Color color) =>
      _navigator.navigateToCommonView(
        walls: colorWalls[color]!,
        title: selectedFilter,
      );

  void navigateToCommonTagView() => _navigator.navigateToCommonView(
        walls: filterWalls[selectedFilter]!,
        title: selectedFilter,
      );

  void navigateToPremiumView() => _navigator.navigateToCommonView(
        walls: premiumWallList,
        title: AppStrings.premiumTitle,
      );

  void navigateToTrendingView() => _navigator.navigateToCommonView(
        walls: trendingCollectionWalls,
        title: AppStrings.trendingCollectionTitle,
      );

  void navigateToAllView() => _navigator.navigateToCommonView(
        walls: originalWallList,
        title: AppStrings.allWallpapers,
      );
}

class Tag {
  List<String> unSelectedTags;
  List<String> selectedTags;

  Tag({required this.selectedTags, required this.unSelectedTags});
}
