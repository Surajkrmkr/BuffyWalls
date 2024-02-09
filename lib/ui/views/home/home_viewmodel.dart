import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/model_export.dart';
import '../../../services/api_service.dart';
import '../../common/common_export.dart';
import '../view_export.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigator = locator<NavigationService>();
  final _categoryModelView = locator<CategoryViewModel>();
  final logger = getLogger('HomeViewModel');

  final ScrollController controller = ScrollController();

  BuffyWallsModel data = BuffyWallsModel();

  List<String> trendingCollection = [];
  List<PopularWall> originalWallList = [];
  List<PopularWall> premiumWallList = [];
  List<PopularWall> trendingCollectionWalls = [];

  Map<String, List<PopularWall>> categories = <String, List<PopularWall>>{};
  Map<String, List<PopularWall>> filterWalls = <String, List<PopularWall>>{};
  Tag tag = Tag(selectedTags: [], unSelectedTags: []);

  String selectedFilter = AppStrings.trendingTitle;

  void onSelectFilter(String value) {
    if (selectedFilter != value) {
      selectedFilter = value;
      rebuildUi();
    }
  }

  Future<void> getWalls() async {
    setBusy(true);
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
    categories.clear();
    filterWalls.clear();
    tag.selectedTags.clear();
    tag.unSelectedTags.clear();
    for (PopularWall wall in originalWallList) {
      if (!categories.containsKey(wall.category)) {
        categories[wall.category] = []; // Initiating a Empty list of a category
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

  void navigateToCommonTagView() => _navigator.navigateToView(
        CommonView(
          walls: filterWalls[selectedFilter]!,
          title: selectedFilter,
        ),
        transitionStyle: Transition.rightToLeftWithFade,
      );

  void navigateToPremiumView() => _navigator.navigateToView(
        CommonView(
          walls: premiumWallList,
          title: AppStrings.premiumTitle,
        ),
        transitionStyle: Transition.rightToLeftWithFade,
      );

  void navigateToTrendingView() => _navigator.navigateToView(
        CommonView(
          walls: trendingCollectionWalls,
          title: AppStrings.trendingCollectionTitle,
        ),
        transitionStyle: Transition.rightToLeftWithFade,
      );

  void navigateToAllView() => _navigator.navigateToView(
        CommonView(
          walls: originalWallList,
          title: AppStrings.allWallpapers,
        ),
        transitionStyle: Transition.rightToLeftWithFade,
      );
}

class Tag {
  List<String> unSelectedTags;
  List<String> selectedTags;

  Tag({required this.selectedTags, required this.unSelectedTags});
}