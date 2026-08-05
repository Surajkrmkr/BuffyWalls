import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../home/home_viewmodel.dart';

/// Backs the dedicated Color landing page — colors treated as mini
/// collections. Everything is derived from [HomeViewModel.colorWalls],
/// which is already built from the existing wallpaper dataset.
class ColorDetailViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  Color color = Colors.black;
  String colorName = '';
  List<PopularWall> walls = [];
  List<PopularWall> trending = [];
  List<PopularWall> latest = [];
  List<String> similarColors = [];

  void init(Color initialColor, String initialColorName) {
    color = initialColor;
    colorName = initialColorName;
    AnalyticsService.instance.logScreenView('color_detail_$initialColorName');

    walls = _homeViewModel.colorWalls[color] ?? [];
    trending = walls.where((w) => w.isHot).toList();
    if (trending.isEmpty) trending = walls.take(10).toList();
    latest = walls.take(10).toList();

    similarColors = HomeViewModel.namedColors.where((n) => n != colorName).toList();

    rebuildUi();
  }
}
