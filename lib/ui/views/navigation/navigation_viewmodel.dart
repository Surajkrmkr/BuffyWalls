import 'package:stacked/stacked.dart';

class NavigationViewModel extends BaseViewModel {
  int currentIndex = 0;

  void setIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      rebuildUi();
    }
  }
}
