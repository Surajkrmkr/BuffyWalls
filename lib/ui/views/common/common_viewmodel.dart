import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.logger.dart';
import '../../../models/model_export.dart';

class CommonViewModel extends BaseViewModel {
  List<List<PopularWall>> walls = [];
  int currentPage = 0;
  List<PopularWall> pageWiseWalls = [];

  final logger = getLogger('CommonViewModel');
  final ScrollController controller = ScrollController();

  void setWalls(List<PopularWall> walls) {
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          logger.i('At the top');
        } else {
          logger.i('At the bottom');
          loadMore();
        }
      }
    });
    this.walls = walls.slices(20).toList();
    pageWiseWalls = this.walls[currentPage];
  }

  Future<void> loadMore() async {
    if (currentPage >= walls.length - 1) return;
    setBusy(true);
    currentPage++;
    await Future.delayed(const Duration(seconds: 1), () {
      pageWiseWalls = [...pageWiseWalls, ...walls[currentPage]];
      setBusy(false);
    });
  }
}
