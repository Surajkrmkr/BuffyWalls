import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../../app/app.logger.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';

class CommonViewModel extends BaseViewModel {
  List<PopularWall> allWallpapers = [];
  List<PopularWall> visibleWallpapers = [];
  int nextIndex = 0;
  final int pageSize = 20;
  bool isLoadingMore = false;
  bool _isInitialized = false;

  List<PopularWall> get pageWiseWalls => visibleWallpapers;

  final logger = getLogger('CommonViewModel');
  final ScrollController controller = ScrollController();

  void setWalls(List<PopularWall> inputWalls, String title) {
    if (_isInitialized) return;
    _isInitialized = true;

    AnalyticsService.instance.logCollectionScreen(title);
    allWallpapers = List.from(inputWalls);

    final initialCount =
        allWallpapers.length < pageSize ? allWallpapers.length : pageSize;
    visibleWallpapers = allWallpapers.sublist(0, initialCount);
    nextIndex = visibleWallpapers.length;

    logger.i(
        'Init CommonViewModel ($title): total=${allWallpapers.length}, visible=${visibleWallpapers.length}, nextIndex=$nextIndex');

    controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!controller.hasClients) return;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    if (currentScroll >= maxScroll - 300) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || nextIndex >= allWallpapers.length) return;
    isLoadingMore = true;
    setBusy(true);

    final prevNextIndex = nextIndex;
    final endIndex = (nextIndex + pageSize > allWallpapers.length)
        ? allWallpapers.length
        : nextIndex + pageSize;

    final itemsToAppend = allWallpapers.sublist(nextIndex, endIndex);
    logger.i(
        'loadMore BEFORE: nextIndex=$prevNextIndex, appending ${itemsToAppend.length} items (range $prevNextIndex..$endIndex)');

    visibleWallpapers.addAll(itemsToAppend);
    nextIndex = endIndex;

    logger.i(
        'loadMore AFTER: nextIndex=$nextIndex, totalVisible=${visibleWallpapers.length}');

    setBusy(false);
    isLoadingMore = false;
  }
}
