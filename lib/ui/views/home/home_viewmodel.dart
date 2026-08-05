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
  final _adsService = locator<AdsService>();
  final logger = getLogger('HomeViewModel');

  final ScrollController controller = ScrollController();
  bool showScrollToTop = false;

  void setupScrollListener() {
    controller.addListener(() {
      final show = controller.offset > 800;
      if (show != showScrollToTop) {
        showScrollToTop = show;
        notifyListeners();
      }
    });
  }

  BuffyWallsModel data = BuffyWallsModel();

  List<String> trendingCollection = [];
  List<PopularWall> originalWallList = [];
  List<PopularWall> premiumWallList = [];
  List<PopularWall> trendingCollectionWalls = [];
  List<PopularWall> topWallpapersList = [];
  List<PopularWall> recommendedWalls = [];

  Map<String, List<PopularWall>> categories = <String, List<PopularWall>>{};
  Map<String, List<PopularWall>> filterWalls = <String, List<PopularWall>>{};
  Map<Color, List<PopularWall>> colorWalls = <Color, List<PopularWall>>{};
  Tag tag = Tag(selectedTags: [], unSelectedTags: []);

  String currentVersion = "1.0.0";

  // Fixed browse-by-color palette, shared by the Home color rail and the
  // dedicated Color detail page's "Similar Colors" cross-links.
  static const List<String> namedColors = [
    'Black',
    'Blue',
    'Purple',
    'Green',
    'Red',
    'Yellow',
    'Orange',
  ];

  String colorLabel(Color color) {
    return namedColors.firstWhereOrNull(
          (name) => name.toLowerCase().toColor().toARGB32() == color.toARGB32(),
        ) ??
        'Color';
  }

  // Multi-select instant local filters applied to the Explore Wallpapers
  // grid (e.g. "Anime" + "Premium", or "Black" + "AMOLED"). Tag/category
  // filters and color filters are AND-combined.
  Set<String> activeTagFilters = {};
  Set<Color> activeColorFilters = {};

  bool get hasActiveFilters =>
      activeTagFilters.isNotEmpty || activeColorFilters.isNotEmpty;

  void toggleTagFilter(String value) {
    if (!activeTagFilters.remove(value)) {
      activeTagFilters.add(value);
    }
    AnalyticsService.instance.logFilterSelected(value);
    rebuildUi();
  }

  void toggleColorFilter(Color color) {
    if (!activeColorFilters.remove(color)) {
      activeColorFilters.add(color);
      AnalyticsService.instance.logColorFilterSelected(
          '0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}');
    }
    rebuildUi();
  }

  void clearFilters() {
    activeTagFilters.clear();
    activeColorFilters.clear();
    rebuildUi();
  }

  List<PopularWall> applyActiveFilters(List<PopularWall> walls) {
    var result = walls;
    if (activeTagFilters.isNotEmpty) {
      result = result.where((wall) {
        return activeTagFilters.every((filter) {
          if (filter == AppStrings.premiumTitle) return wall.isPremium;
          final f = filter.toLowerCase();
          return wall.category.toLowerCase() == f ||
              wall.tags.any((t) => t.toLowerCase() == f);
        });
      }).toList();
    }
    if (activeColorFilters.isNotEmpty) {
      result = result.where((wall) {
        return activeColorFilters
            .every((c) => wall.colors.any((wc) => wc.toARGB32() == c.toARGB32()));
      }).toList();
    }
    return result;
  }

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  Future<void> getWalls() async {
    AnalyticsService.instance.logHomeScreen();
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
    BuffyService.hydrate(originalWallList);
    MonetizationService.hydrate();
    _extractCategoryAndTags();
    final topIds = data.topWallpapers.toSet();
    final topWalls = data.topWallpapers
        .map((id) => originalWallList.firstWhereOrNull((w) => w.id == id))
        .whereType<PopularWall>()
        .toList();
    final remainingWalls =
        originalWallList.where((w) => !topIds.contains(w.id)).toList();
    topWallpapersList = [...topWalls, ...remainingWalls];
    recommendedWalls = getRecommendedWallpapers();
    _categoryModelView.setCategory(categories);
    setBusy(false);
    _adsService.loadDialogAd();
  }

  /// Recomputes [recommendedWalls] from the latest local activity signals.
  /// Cheap to call occasionally (e.g. after favouriting), but deliberately
  /// NOT called from every `rebuildUi()` — the scoring pass walks the full
  /// wallpaper list, so it must stay off the widget build path.
  void refreshRecommendations() {
    recommendedWalls = getRecommendedWallpapers();
    rebuildUi();
  }

  /// Called after [RewardBanner] unlocks a wallpaper so the milestone
  /// progress / Explore grid badges reflect it immediately.
  void notifyRewardStateChanged() => rebuildUi();

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
        if (trendingCollection.contains(eachTag) &&
            !trendingCollectionWalls.contains(wall)) {
          trendingCollectionWalls.add(wall);
        }
        if (data.trendingTags.contains(eachTag)) {
          if (!filterWalls.containsKey(eachTag)) {
            filterWalls[eachTag] = [];
          }
          filterWalls[eachTag]!.add(wall);
        }
      }
      if (data.hotCollectionIds.contains(wall.id)) {
        trendingCollectionWalls.add(wall);
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
    refreshRecommendations();
  }

  void clearData() {
    categories.clear();
    colorWalls.clear();
    filterWalls.clear();
    trendingCollectionWalls.clear();
    topWallpapersList.clear();
    tag.selectedTags.clear();
    tag.unSelectedTags.clear();
  }

  void checkInAppUpdate() {
    InAppUpdate.checkForUpdate().then((updateInfo) async {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    }, onError: (error) {
      logger.e(error);
    });
  }

  void navigateToCommonColorView(Color color) {
    final colorHex = '0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    AnalyticsService.instance.logColorFilterSelected(colorHex);
    _navigator.navigateToCommonView(
      walls: colorWalls[color] ?? [],
      title: colorLabel(color),
    );
  }

  /// Robustly resolves the wallpapers behind a curated collection name.
  /// `hotCollections` entries aren't guaranteed to also exist as
  /// `trendingTags`, so this falls back through category and tag matches
  /// instead of assuming a single map key.
  List<PopularWall> wallsForCollection(String name) {
    if ((filterWalls[name] ?? []).isNotEmpty) return filterWalls[name]!;
    if ((categories[name] ?? []).isNotEmpty) return categories[name]!;
    final lower = name.toLowerCase();
    final tagMatches = originalWallList
        .where((w) => w.tags.any((t) => t.toLowerCase() == lower))
        .toList();
    if (tagMatches.isNotEmpty) return tagMatches;
    return trendingCollectionWalls;
  }

  void navigateToCategoryDetailView(String category) {
    AnalyticsService.instance.logCategoryClick(category);
    _navigator.navigateToCategoryDetailView(category: category);
  }

  void navigateToColorDetailView(Color color) {
    final colorHex = '0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    AnalyticsService.instance.logColorFilterSelected(colorHex);
    _navigator.navigateToColorDetailView(color: color, colorName: colorLabel(color));
  }

  void navigateToCollectionDetailView(String collection) {
    AnalyticsService.instance.logCollectionClick(collection);
    _navigator.navigateToCollectionDetailView(collection: collection);
  }

  void navigateToPremiumView() {
    AnalyticsService.instance.logCollectionOpened(AppStrings.premiumTitle);
    _navigator.navigateToCommonView(
      walls: premiumWallList,
      title: AppStrings.premiumTitle,
    );
  }

  void navigateToTrendingView() {
    AnalyticsService.instance
        .logCollectionOpened(AppStrings.trendingCollectionTitle);
    _navigator.navigateToCommonView(
      walls: trendingCollectionWalls,
      title: AppStrings.trendingCollectionTitle,
    );
  }

  void navigateToAllView() {
    AnalyticsService.instance.logCollectionOpened(AppStrings.allWallpapers);
    _navigator.navigateToCommonView(
      walls: topWallpapersList,
      title: AppStrings.allWallpapers,
    );
  }

  void navigateToBanner(AdBanner banner) {
    AnalyticsService.instance
        .logBannerTapped(banner.id.toString(), banner.category);
    if (banner.link.isNotEmpty) {
      launchUrl(Uri.parse(banner.link), mode: LaunchMode.externalApplication);
      return;
    }
    if (banner.category.isNotEmpty) {
      _navigator.navigateToCommonView(
        walls: categories[banner.category]!,
        title: banner.category,
      );
    }
  }

  /// "Recommended For You" — a local, on-device profile built from
  /// everything the user has interacted with this device (viewed,
  /// favourited, downloaded, applied), scored via [RecommendationEngine].
  /// Falls back to Trending/Hot/Latest when there's no history yet, so the
  /// section is always populated.
  List<PopularWall> getRecommendedWallpapers() {
    if (originalWallList.isEmpty) return [];

    final downloadedAndApplied = {
      ...BuffyService.downloadedIds,
      ...BuffyService.appliedIds,
    }
        .map((id) => originalWallList.firstWhereOrNull((w) => w.id == id))
        .whereType<PopularWall>();

    final profile = <PopularWall>{
      ...BuffyService.sessionHistory,
      ..._favouriteViewModel.allWalls,
      ...downloadedAndApplied,
    };

    if (profile.isEmpty) {
      return RecommendationEngine.recommend(
        pool: originalWallList,
        limit: 10,
        randomSeed: DateTime.now().day,
      );
    }

    final premiumCount = profile.where((w) => w.isPremium).length;

    return RecommendationEngine.recommend(
      pool: originalWallList,
      excludeIds: profile.map((w) => w.id).toSet(),
      categories: profile.map((w) => w.category).toSet(),
      tags: profile.expand((w) => w.tags).toSet(),
      colorValues: profile.expand((w) => w.colors).map((c) => c.toARGB32()).toSet(),
      premiumLean: premiumCount > profile.length / 2,
      limit: 10,
      randomSeed: DateTime.now().day,
    );
  }
}

class Tag {
  List<String> unSelectedTags;
  List<String> selectedTags;

  Tag({required this.selectedTags, required this.unSelectedTags});
}
