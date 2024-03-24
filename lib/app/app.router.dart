// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:buffywalls/models/model_export.dart' as _i5;
import 'package:buffywalls/ui/views/onboard/onboard_view.dart' as _i3;
import 'package:buffywalls/ui/views/view_export.dart' as _i2;
import 'package:flutter/material.dart' as _i4;
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

  static const all = <String>{
    startupView,
    navigationView,
    commonView,
    settingsView,
    imageView,
    searchView,
    onboardView,
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
      page: _i3.OnboardView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i2.NavigationView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.NavigationView(),
        settings: data,
      );
    },
    _i2.CommonView: (data) {
      final args = data.getArgs<CommonViewArguments>(nullOk: false);
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i2.CommonView(key: args.key, walls: args.walls, title: args.title),
        settings: data,
      );
    },
    _i2.SettingsView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SettingsView(),
        settings: data,
      );
    },
    _i2.ImageView: (data) {
      final args = data.getArgs<ImageViewArguments>(nullOk: false);
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.ImageView(key: args.key, wall: args.wall),
        settings: data,
      );
    },
    _i2.SearchView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SearchView(),
        settings: data,
      );
    },
    _i3.OnboardView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.OnboardView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class CommonViewArguments {
  const CommonViewArguments({
    this.key,
    required this.walls,
    required this.title,
  });

  final _i4.Key? key;

  final List<_i5.PopularWall> walls;

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

class ImageViewArguments {
  const ImageViewArguments({
    this.key,
    required this.wall,
  });

  final _i4.Key? key;

  final _i5.PopularWall wall;

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
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i2.CategoryView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.CategoryView(),
        settings: data,
      );
    },
    _i2.FavouriteView: (data) {
      return _i4.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.FavouriteView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i6.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNavigationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.navigationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCommonView({
    _i4.Key? key,
    required List<_i5.PopularWall> walls,
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

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToImageView({
    _i4.Key? key,
    required _i5.PopularWall wall,
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

  Future<dynamic> navigateToSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.onboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedHomeViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(NavigationViewRoutes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedCategoryViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(NavigationViewRoutes.categoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedFavouriteViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(NavigationViewRoutes.favouriteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNavigationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.navigationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCommonView({
    _i4.Key? key,
    required List<_i5.PopularWall> walls,
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

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithImageView({
    _i4.Key? key,
    required _i5.PopularWall wall,
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

  Future<dynamic> replaceWithSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.onboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedHomeViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(NavigationViewRoutes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedCategoryViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(NavigationViewRoutes.categoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedFavouriteViewInNavigationViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(NavigationViewRoutes.favouriteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
