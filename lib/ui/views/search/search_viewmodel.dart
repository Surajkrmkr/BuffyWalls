import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../view_export.dart';

class SearchViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  final _sharedPrefService = locator<SharedPrefService>();
  final logger = getLogger('SearchViewModel');

  List<PopularWall> allWallpapers = [];
  List<PopularWall> visibleWallpapers = [];
  int nextIndex = 0;
  final int pageSize = 20;
  bool isLoadingMore = false;

  List<PopularWall> noResultSuggestions = [];
  List<String> suggestions = [];
  List<String> recentSearches = [];

  List<String> get popularWords => _homeViewModel.data.trendingTags;
  List<Color> get hotColors => _homeViewModel.data.hotColors;

  bool get hasQuery => textEditingController.text.trim().isNotEmpty;
  bool get showNoResults => hasQuery && visibleWallpapers.isEmpty;

  List<PopularWall> get pageWiseWalls => visibleWallpapers;

  final ScrollController controller = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  void init() {
    AnalyticsService.instance.logSearchScreen();
    recentSearches = _sharedPrefService.getRecentSearches();
    controller.addListener(_onScroll);
    setWalls(_homeViewModel.originalWallList);
  }

  void _onScroll() {
    if (!controller.hasClients) return;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    if (currentScroll >= maxScroll - 300) {
      loadMore();
    }
  }

  void setWalls(List<PopularWall> queryWalls) {
    allWallpapers = List.from(queryWalls);
    if (allWallpapers.isEmpty) {
      visibleWallpapers = [];
      nextIndex = 0;
      rebuildUi();
      return;
    }
    final initialCount =
        allWallpapers.length < pageSize ? allWallpapers.length : pageSize;
    visibleWallpapers = allWallpapers.sublist(0, initialCount);
    nextIndex = visibleWallpapers.length;
    rebuildUi();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || nextIndex >= allWallpapers.length) return;
    isLoadingMore = true;
    setBusy(true);

    final prevNextIndex = nextIndex;
    final endIndex = (nextIndex + pageSize > allWallpapers.length)
        ? allWallpapers.length
        : nextIndex + pageSize;

    final itemsToAppend = allWallpapers.sublist(nextIndex, endIndex);
    logger.i(
        'Search loadMore BEFORE: nextIndex=$prevNextIndex, appending ${itemsToAppend.length} items (range $prevNextIndex..$endIndex)');

    visibleWallpapers.addAll(itemsToAppend);
    nextIndex = endIndex;

    logger.i(
        'Search loadMore AFTER: nextIndex=$nextIndex, totalVisible=${visibleWallpapers.length}');

    setBusy(false);
    isLoadingMore = false;
  }

  void onSearch(String value) {
    final query = value.trim().toLowerCase();
    List<PopularWall> queryWalls;
    if (query.isEmpty) {
      queryWalls = _homeViewModel.originalWallList;
      suggestions = [];
      noResultSuggestions = [];
    } else {
      AnalyticsService.instance.logSearch(value.trim());
      queryWalls = _matchingWalls(query);
      suggestions = _buildSuggestions(query);
      noResultSuggestions = queryWalls.isEmpty ? _fallbackWalls() : [];
    }
    setWalls(queryWalls);
    rebuildUi();
  }

  /// Instant local search across name, category, tags, designer, and color
  /// name — no additional API calls.
  List<PopularWall> _matchingWalls(String query) {
    final matchingColorValues = HomeViewModel.namedColors
        .where((name) => name.toLowerCase().contains(query))
        .map((name) => name.toLowerCase().toColor().toARGB32())
        .toSet();

    return _homeViewModel.originalWallList.where((wall) {
      if (wall.name.toLowerCase().contains(query)) return true;
      if (wall.designer.toLowerCase().contains(query)) return true;
      if (wall.category.toLowerCase().contains(query)) return true;
      if (wall.tags.any((t) => t.toLowerCase().contains(query))) return true;
      if (matchingColorValues.isNotEmpty &&
          wall.colors.any((c) => matchingColorValues.contains(c.toARGB32()))) {
        return true;
      }
      return false;
    }).toList();
  }

  List<String> _buildSuggestions(String query) {
    final matches = <String>{
      ..._homeViewModel.data.trendingTags.where((t) => t.toLowerCase().contains(query)),
      ..._homeViewModel.categories.keys.where((c) => c.toLowerCase().contains(query)),
      ..._homeViewModel.originalWallList
          .map((w) => w.designer)
          .where((d) => d.isNotEmpty && d.toLowerCase().contains(query)),
    };
    return matches.take(6).toList();
  }

  List<PopularWall> _fallbackWalls() {
    return RecommendationEngine.recommend(
      pool: _homeViewModel.originalWallList,
      limit: 10,
      randomSeed: DateTime.now().day,
    );
  }

  void onWordSelected(String value) {
    AnalyticsService.instance.logPopularWordSelected(value);
    _runSearch(value);
  }

  void onSuggestionSelected(String value) => _runSearch(value);

  void onRecentSearchSelected(String value) => _runSearch(value);

  void onSubmitted(String value) => _saveRecentSearch(value);

  void _runSearch(String value) {
    textEditingController.text = value;
    onSearch(value);
    _saveRecentSearch(value);
  }

  void _saveRecentSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    recentSearches.removeWhere((s) => s.toLowerCase() == query.toLowerCase());
    recentSearches.insert(0, query);
    if (recentSearches.length > 8) {
      recentSearches = recentSearches.sublist(0, 8);
    }
    _sharedPrefService.setRecentSearches(recentSearches);
    rebuildUi();
  }

  void clearRecentSearches() {
    recentSearches = [];
    _sharedPrefService.setRecentSearches([]);
    rebuildUi();
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
