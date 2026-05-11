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

  Widget _wallListViewUI(List<PopularWall> walls) {
    final List<Widget> children = [];
    for (int i = 0; i < walls.length; i += 3) {
      final rowIndex = i ~/ 3;
      if (rowIndex > 0 && rowIndex % 4 == 0) {
        children.add(const SizedBox(height: 10));
        children.add(const GridAdWidget());
      }
      if (rowIndex > 0) children.add(const SizedBox(height: 10));
      children.add(_wallRowUI(
        walls[i],
        i + 1 < walls.length ? walls[i + 1] : null,
        i + 2 < walls.length ? walls[i + 2] : null,
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: children),
    );
  }

  Widget _wallRowUI(PopularWall left, PopularWall? mid, PopularWall? right) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
              aspectRatio: 0.6, child: BuffyImage(wall: left)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: mid != null
              ? AspectRatio(aspectRatio: 0.6, child: BuffyImage(wall: mid))
              : const SizedBox(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: right != null
              ? AspectRatio(aspectRatio: 0.6, child: BuffyImage(wall: right))
              : const SizedBox(),
        ),
      ],
    );
  }
}
