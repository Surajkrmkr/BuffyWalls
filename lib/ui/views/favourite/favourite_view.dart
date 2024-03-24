import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'favourite_viewmodel.dart';

class FavouriteView extends StackedView<FavouriteViewModel> {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FavouriteViewModel viewModel,
    Widget? child,
  ) {
    return CustomScrollView(
      controller: viewModel.controller,
      slivers: [
        const BuffyAppBar(
          title: AppStrings.favouriteTitle,
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
    );
  }

  @override
  FavouriteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      locator<FavouriteViewModel>();

  @override
  void onViewModelReady(FavouriteViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  get disposeViewModel => false;

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
