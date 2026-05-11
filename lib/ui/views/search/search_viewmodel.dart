import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../view_export.dart';

class SearchViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  final logger = getLogger('SearchViewModel');

  List<List<PopularWall>> walls = [];
  List<PopularWall> pageWiseWalls = [];
  List<String> get popularWords => _homeViewModel.data.trendingTags;
  List<Color> get hotColors => _homeViewModel.data.hotColors;

  int currentPage = 0;

  final ScrollController controller = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  void init() {
    AnalyticsService.instance.logSearchScreen();
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
    setWalls(_homeViewModel.originalWallList);
  }

  void setWalls(List<PopularWall> queryWalls) {
    currentPage = 0;
    if (queryWalls.isEmpty) {
      pageWiseWalls = [];
      return;
    }
    walls = queryWalls.slices(20).toList();
    pageWiseWalls = walls[currentPage];
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

  void onSearch(String value) {
    List<PopularWall> queryWalls = [];
    if (value.isEmpty) {
      queryWalls = _homeViewModel.originalWallList;
    } else {
      AnalyticsService.instance.logSearch(value.trim());
      queryWalls = _homeViewModel.originalWallList
          .where((element) => (element.tags.any((tag) =>
                  tag.toLowerCase().contains(value.trim().toLowerCase())) ||
              element.name.toLowerCase().contains(value.trim().toLowerCase())))
          .toList();
    }
    setWalls(queryWalls);
    rebuildUi();
  }

  void onWordSelected(String value) {
    AnalyticsService.instance.logPopularWordSelected(value);
    textEditingController.text = value;
    onSearch(value);
  }

  void navigateToCommonColorView(Color color) {
    final colorHex =
        '0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    AnalyticsService.instance.logColorFilterSelected(colorHex);
    _homeViewModel.navigateToCommonColorView(color);
  }

  void onClear() {
    textEditingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    onSearch('');
  }
}
