// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i5;

import 'package:buffywalls/models/model_export.dart' as _i4;
import 'package:buffywalls/ui/views/view_export.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i6;

class Routes {
  static const startupView = '/startup-view';

  static const navigationView = '/navigation-view';

  static const commonView = '/common-view';

  static const settingsView = '/settings-view';

  static const imageView = '/image-view';

  static const searchView = '/search-view';

  static const onboardView = '/onboard-view';

  static const categoryDetailView = '/category-detail-view';

  static const colorDetailView = '/color-detail-view';

  static const collectionDetailView = '/collection-detail-view';

  static const all = <String>{
    startupView,
    navigationView,
    commonView,
    settingsView,
    imageView,
    searchView,
    onboardView,
    categoryDetailView,
    colorDetailView,
    collectionDetailView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.navigationView,
      page: _i2.NavigationView,
    ),
    _i1.RouteDef(
      Routes.commonView,
      page: _i2.CommonView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i2.SettingsView,
    ),
    _i1.RouteDef(
      Routes.imageView,
      page: _i2.ImageView,
    ),
    _i1.RouteDef(
      Routes.searchView,
      page: _i2.SearchView,
    ),
    _i1.RouteDef(
      Routes.onboardView,
      page: _i2.OnboardView,
    ),
    _i1.RouteDef(
      Routes.categoryDetailView,
      page: _i2.CategoryDetailView,
    ),
    _i1.RouteDef(
      Routes.colorDetailView,
      page: _i2.ColorDetailView,
    ),
    _i1.RouteDef(
      Routes.collectionDetailView,
      page: _i2.CollectionDetailView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.StartupView(key: args.key),
        settings: data,
      );
    },
    _i2.NavigationView: (data) {
      final args = data.getArgs<NavigationViewArguments>(
        orElse: () => const NavigationViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.NavigationView(key: args.key),
        settings: data,
      );
    },
    _i2.CommonView: (data) {
      final args = data.getArgs<CommonViewArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i2.CommonView(key: args.key, walls: args.walls, title: args.title),
        settings: data,
      );
    },
    _i2.SettingsView: (data) {
      final args = data.getArgs<SettingsViewArguments>(
        orElse: () => const SettingsViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SettingsView(key: args.key),
        settings: data,
      );
    },
    _i2.ImageView: (data) {
      final args = data.getArgs<ImageViewArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.ImageView(key: args.key, wall: args.wall),
        settings: data,
      );
    },
    _i2.SearchView: (data) {
      final args = data.getArgs<SearchViewArguments>(
        orElse: () => const SearchViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SearchView(key: args.key),
        settings: data,
      );
    },
    _i2.OnboardView: (data) {
      final args = data.getArgs<OnboardViewArguments>(
        orElse: () => const OnboardViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.OnboardView(key: args.key),
        settings: data,
      );
    },
    _i2.CategoryDetailView: (data) {
      final args = data.getArgs<CategoryDetailViewArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i2.CategoryDetailView(key: args.key, category: args.category),
        settings: data,
      );
    },
    _i2.ColorDetailView: (data) {
      final args = data.getArgs<ColorDetailViewArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.ColorDetailView(
            key: args.key, color: args.color, colorName: args.colorName),
        settings: data,
      );
    },
    _i2.CollectionDetailView: (data) {
      final args = data.getArgs<CollectionDetailViewArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.CollectionDetailView(
            key: args.key, collection: args.collection),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class NavigationViewArguments {
  const NavigationViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant NavigationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CommonViewArguments {
  const CommonViewArguments({
    this.key,
    required this.walls,
    required this.title,
  });

  final _i3.Key? key;

  final List<_i4.PopularWall> walls;

  final String title;

  @override
  String toString() {
    return '{"key": "$key", "walls": "$walls", "title": "$title"}';
  }

  @override
  bool operator ==(covariant CommonViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.walls == walls && other.title == title;
  }

  @override
  int get hashCode {
    return key.hashCode ^ walls.hashCode ^ title.hashCode;
  }
}

class SettingsViewArguments {
  const SettingsViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SettingsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ImageViewArguments {
  const ImageViewArguments({
    this.key,
    required this.wall,
  });

  final _i3.Key? key;

  final _i4.PopularWall wall;

  @override
  String toString() {
    return '{"key": "$key", "wall": "$wall"}';
  }

  @override
  bool operator ==(covariant ImageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.wall == wall;
  }

  @override
  int get hashCode {
    return key.hashCode ^ wall.hashCode;
  }
}

class SearchViewArguments {
  const SearchViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SearchViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OnboardViewArguments {
  const OnboardViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OnboardViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CategoryDetailViewArguments {
  const CategoryDetailViewArguments({
    this.key,
    required this.category,
  });

  final _i3.Key? key;

  final String category;

  @override
  String toString() {
    return '{"key": "$key", "category": "$category"}';
  }

  @override
  bool operator ==(covariant CategoryDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.category == category;
  }

  @override
  int get hashCode {
    return key.hashCode ^ category.hashCode;
  }
}

class ColorDetailViewArguments {
  const ColorDetailViewArguments({
    this.key,
    required this.color,
    required this.colorName,
  });

  final _i3.Key? key;

  final _i5.Color color;

  final String colorName;

  @override
  String toString() {
    return '{"key": "$key", "color": "$color", "colorName": "$colorName"}';
  }

  @override
  bool operator ==(covariant ColorDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.color == color &&
        other.colorName == colorName;
  }

  @override
  int get hashCode {
    return key.hashCode ^ color.hashCode ^ colorName.hashCode;
  }
}

class CollectionDetailViewArguments {
  const CollectionDetailViewArguments({
    this.key,
    required this.collection,
  });

  final _i3.Key? key;

  final String collection;

  @override
  String toString() {
    return '{"key": "$key", "collection": "$collection"}';
  }

  @override
  bool operator ==(covariant CollectionDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.collection == collection;
  }

  @override
  int get hashCode {
    return key.hashCode ^ collection.hashCode;
  }
}

class NavigationViewRoutes {
  static const homeView = 'home-view';

  static const categoryView = 'category-view';

  static const favouriteView = 'favourite-view';

  static const all = <String>{
    homeView,
    categoryView,
    favouriteView,
  };
}

class NavigationViewRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      NavigationViewRoutes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      NavigationViewRoutes.categoryView,
      page: _i2.CategoryView,
    ),
    _i1.RouteDef(
      NavigationViewRoutes.favouriteView,
      page: _i2.FavouriteView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<NestedHomeViewArguments>(
        orElse: () => const NestedHomeViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i2.CategoryView: (data) {
      final args = data.getArgs<NestedCategoryViewArguments>(
        orElse: () => const NestedCategoryViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.CategoryView(key: args.key),
        settings: data,
      );
    },
    _i2.FavouriteView: (data) {
      final args = data.getArgs<NestedFavouriteViewArguments>(
        orElse: () => const NestedFavouriteViewArguments(),
      );
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.FavouriteView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class NestedHomeViewArguments {
  const NestedHomeViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant NestedHomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class NestedCategoryViewArguments {
  const NestedCategoryViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant NestedCategoryViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class NestedFavouriteViewArguments {
  const NestedFavouriteViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant NestedFavouriteViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i6.NavigationService {
  Future<dynamic> navigateToStartupView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNavigationView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.navigationView,
        arguments: NavigationViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCommonView({
    _i3.Key? key,
    required List<_i4.PopularWall> walls,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.commonView,
        arguments: CommonViewArguments(key: key, walls: walls, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.settingsView,
        arguments: SettingsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToImageView({
    _i3.Key? key,
    required _i4.PopularWall wall,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.imageView,
        arguments: ImageViewArguments(key: key, wall: wall),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.searchView,
        arguments: SearchViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnboardView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.onboardView,
        arguments: OnboardViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCategoryDetailView({
    _i3.Key? key,
    required String category,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.categoryDetailView,
        arguments: CategoryDetailViewArguments(key: key, category: category),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToColorDetailView({
    _i3.Key? key,
    required _i5.Color color,
    required String colorName,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.colorDetailView,
        arguments: ColorDetailViewArguments(
            key: key, color: color, colorName: colorName),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCollectionDetailView({
    _i3.Key? key,
    required String collection,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.collectionDetailView,
        arguments:
            CollectionDetailViewArguments(key: key, collection: collection),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedHomeViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(NavigationViewRoutes.homeView,
        arguments: NestedHomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedCategoryViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(NavigationViewRoutes.categoryView,
        arguments: NestedCategoryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedFavouriteViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(NavigationViewRoutes.favouriteView,
        arguments: NestedFavouriteViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNavigationView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.navigationView,
        arguments: NavigationViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCommonView({
    _i3.Key? key,
    required List<_i4.PopularWall> walls,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.commonView,
        arguments: CommonViewArguments(key: key, walls: walls, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.settingsView,
        arguments: SettingsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithImageView({
    _i3.Key? key,
    required _i4.PopularWall wall,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.imageView,
        arguments: ImageViewArguments(key: key, wall: wall),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.searchView,
        arguments: SearchViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.onboardView,
        arguments: OnboardViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCategoryDetailView({
    _i3.Key? key,
    required String category,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.categoryDetailView,
        arguments: CategoryDetailViewArguments(key: key, category: category),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithColorDetailView({
    _i3.Key? key,
    required _i5.Color color,
    required String colorName,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.colorDetailView,
        arguments: ColorDetailViewArguments(
            key: key, color: color, colorName: colorName),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCollectionDetailView({
    _i3.Key? key,
    required String collection,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.collectionDetailView,
        arguments:
            CollectionDetailViewArguments(key: key, collection: collection),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedHomeViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(NavigationViewRoutes.homeView,
        arguments: NestedHomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedCategoryViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(NavigationViewRoutes.categoryView,
        arguments: NestedCategoryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedFavouriteViewInNavigationViewRouter({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(NavigationViewRoutes.favouriteView,
        arguments: NestedFavouriteViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
