import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../home/home_viewmodel.dart';

/// Backs the dedicated Category landing page. Pulls everything from the
/// already-computed [HomeViewModel] maps — no backend calls, no new data.
class CategoryDetailViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  String category = '';
  List<PopularWall> walls = [];
  List<PopularWall> trending = [];
  List<PopularWall> latest = [];
  List<String> relatedCategories = [];
  List<String> relatedCollections = [];

  PopularWall? get heroWall =>
      walls.firstWhereOrNull((w) => w.isHot) ??
      (walls.isNotEmpty ? walls.first : null);

  void init(String categoryName) {
    category = categoryName;
    AnalyticsService.instance.logScreenView('category_detail_$categoryName');
    AnalyticsService.instance.logCategoryClick(categoryName);

    walls = _homeViewModel.categories[categoryName] ?? [];
    trending = walls.where((w) => w.isHot).toList();
    if (trending.isEmpty) trending = walls.take(10).toList();
    latest = walls.take(10).toList();

    relatedCategories =
        _homeViewModel.categories.keys.where((c) => c != categoryName).toList();
    relatedCollections = _homeViewModel.data.hotCollections.where((name) {
      return _homeViewModel
          .wallsForCollection(name)
          .any((w) => w.category == categoryName);
    }).toList();

    rebuildUi();
  }
}
