import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.logger.dart';
import '../../../models/model_export.dart';

@lazySingleton
class CategoryViewModel extends BaseViewModel {
  int currentIndex = 0;
  final logger = getLogger('CategoryViewModel');

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
}
