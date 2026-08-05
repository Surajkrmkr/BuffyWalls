import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../home/home_viewmodel.dart';

/// Backs the editorial Collection landing page. Collection membership is
/// resolved via [HomeViewModel.wallsForCollection], which robustly falls
/// back across the existing tag/category data instead of assuming a
/// single map key — no new backend data required.
class CollectionDetailViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  String collection = '';
  List<PopularWall> walls = [];
  List<PopularWall> featured = [];
  List<PopularWall> explore = [];
  List<String> relatedCollections = [];

  PopularWall? get heroWall => walls.isNotEmpty ? walls.first : null;

  String get description {
    final count = walls.length;
    return "A handpicked collection of $count wallpaper${count == 1 ? '' : 's'} — "
        "curated by Team Shadow and updated regularly.";
  }

  void init(String collectionName) {
    collection = collectionName;
    AnalyticsService.instance.logScreenView('collection_detail_$collectionName');
    AnalyticsService.instance.logCollectionClick(collectionName);

    walls = _homeViewModel.wallsForCollection(collectionName);
    featured = walls.take(6).toList();
    explore = walls.length > 6 ? walls.sublist(6) : [];

    relatedCollections = _homeViewModel.data.hotCollections
        .where((c) => c != collectionName)
        .toList();

    rebuildUi();
  }
}
