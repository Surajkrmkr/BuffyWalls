import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/model_export.dart';
import '../../../services/api_service.dart';
import '../view_export.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _categoryModelView = locator<CategoryViewModel>();
  final logger = getLogger('HomeViewModel');

  bool visible = true;

  final ScrollController controller = ScrollController();

  HomeViewModel() {
    hideNavbar();
  }

  BuffyWallsModel data = BuffyWallsModel();

  List<String> trendingCollection = [];

  List<PopularWall> originalWallList = [];
  List<PopularWall> trendingCollectionWalls = [];

  Map<String, List<PopularWall>> categories = <String, List<PopularWall>>{};
  Tag tag = Tag(selectedTags: [], unSelectedTags: []);

  set setVisible(bool val) {
    visible = val;
    rebuildUi();
  }

  void hideNavbar() {
    setVisible = true;
    controller.addListener(
      () {
        if (controller.positions.last.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible) {
            setVisible = false;
          }
        }

        if (controller.positions.last.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible) {
            setVisible = true;
          }
        }
      },
    );
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
      }
      categories[wall.category]!.add(wall); // Adding a Wall to CategoryList
    }
  }
}

class Tag {
  List<String> unSelectedTags;
  List<String> selectedTags;

  Tag({required this.selectedTags, required this.unSelectedTags});
}
