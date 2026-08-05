import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/service_export.dart';
import '../view_export.dart';

@lazySingleton
class NavigationViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  int currentIndex = 0;
  bool navBarVisible = true;

  void setIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      const tabs = ['home', 'category', 'favourite'];
      AnalyticsService.instance.logTabChanged(index, tabs[index]);
      AnalyticsService.instance.logScreenView(tabs[index]);
      rebuildUi();
    }
  }

  set setVisible(bool val) {
    navBarVisible = val;
    rebuildUi();
  }

  void hideNavbar() {
    setVisible = true;
    _homeViewModel.controller.addListener(
      () {
        if (_homeViewModel.controller.positions.last.userScrollDirection ==
                ScrollDirection.reverse &&
            navBarVisible) {
          setVisible = false;
        }

        if (_homeViewModel.controller.positions.last.userScrollDirection ==
                ScrollDirection.forward &&
            !navBarVisible) {
          setVisible = true;
        }
      },
    );
  }

  Future<void> refresh() => _homeViewModel.getWalls();
}
