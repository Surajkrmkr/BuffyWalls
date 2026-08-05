import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'common_viewmodel.dart';

class CommonView extends StackedView<CommonViewModel> {
  final String title;
  final List<PopularWall> walls;
  const CommonView({Key? key, required this.walls, required this.title})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CommonViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: viewModel.controller,
                slivers: [
                  BuffyAppBar(
                    title: title,
                    showBackBtn: true,
                  ),
                  SliverToBoxAdapter(
                      child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _wallListViewUI(viewModel.pageWiseWalls),
                      Visibility(
                        visible: viewModel.isBusy,
                        child: const SizedBox.square(
                            dimension: 30,
                            child: Center(child: CircularProgressIndicator())),
                      ),
                      verticalSpaceSmall
                    ],
                  ))
                ],
              ),
            ),
            verticalSpaceSmall,
            const AdsWidget()
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(CommonViewModel viewModel) =>
      viewModel.setWalls(walls, title);

  @override
  void onDispose(CommonViewModel viewModel) {
    viewModel.controller.dispose();
  }

  @override
  CommonViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CommonViewModel();

  // CommonView already paginates externally (viewModel.loadMore() appends
  // slices(20) on scroll), so WallpaperGridSection's own "Load More" is
  // disabled here via a pageSize larger than any realistic page — showing
  // two competing pagination controls would be confusing.
  Widget _wallListViewUI(List<PopularWall> walls) {
    return WallpaperGridSection(walls: walls, pageSize: 1000000);
  }
}
