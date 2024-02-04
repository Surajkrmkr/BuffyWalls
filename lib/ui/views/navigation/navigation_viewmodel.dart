import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../view_export.dart';

@lazySingleton
class NavigationViewModel extends BaseViewModel {
  int currentIndex = 0;
  final _homeViewModel = locator<HomeViewModel>();

  void setIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      rebuildUi();
    }
  }

  Future<void> refresh() => _homeViewModel.getWalls();
}
