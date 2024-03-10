import 'package:buffywalls/app/app.router.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/model_export.dart';
import '../view_export.dart';

@lazySingleton
class CategoryViewModel extends BaseViewModel {
  final logger = getLogger('CategoryViewModel');
  final _navigator = locator<NavigationService>();

  int currentIndex = 0;

  Map<String, List<PopularWall>> categories = <String, List<PopularWall>>{};

  void setIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      rebuildUi();
    }
  }

  void setCategory(Map<String, List<PopularWall>> value) {
    categories = value;
    rebuildUi();
  }

  void navigateToMoreView(String title) => _navigator.navigateToCommonView(
        title: title,
        walls: categories[title]!,
      );
}
