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
    );
  }

  @override
  void onViewModelReady(CommonViewModel viewModel) => viewModel.setWalls(walls);

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
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: walls.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final wall = walls[index];
        return BuffyImage(wall: wall);
      },
    );
  }
}
