import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../view_export.dart';

@lazySingleton
class NavigationViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  int currentIndex = 0;
  bool navBarVisible = true;

  void setIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
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
            navBarVisible) setVisible = false;

        if (_homeViewModel.controller.positions.last.userScrollDirection ==
                ScrollDirection.forward &&
            !navBarVisible) setVisible = true;
      },
    );
  }

  Future<void> refresh() => _homeViewModel.getWalls();
}
