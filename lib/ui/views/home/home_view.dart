import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) {
        return CustomScrollView(
          controller: viewModel.controller,
          slivers: [
            const BuffyAppBar(title: AppStrings.buffyWallsTitle),
            SliverToBoxAdapter(
              child: viewModel.hasError
                  ? const Center(
                      child: Text(
                        AppStrings.errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : _bodyUI(viewModel, context),
            ),
          ],
        );
      },
      onViewModelReady: (viewModel) => viewModel.getWalls(),
      onDispose: (viewModel) {
        viewModel.logger.i("onDispose");
      },
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
    );
  }

  Widget _bodyUI(HomeViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        verticalSpaceSmall,
        _chipsUI(viewModel, context),
        verticalSpaceSmall,
        _headerUI(
          AppStrings.trendingCollectionTitle,
          context,
          showViewIcon: true,
          onTap: viewModel.navigateToTrendingView,
        ),
        _trendingUI(viewModel, context),
        verticalSpaceSmall,
        _headerUI(AppStrings.searchByColors, context),
        verticalSpaceSmall,
        _colorsUI(viewModel, context),
        verticalSpaceSmall,
        _headerUI(
          AppStrings.allWallpapers,
          context,
          showViewIcon: true,
          onTap: viewModel.navigateToAllView,
        ),
        _allWallUI(viewModel, context),
        verticalSpaceSmall,
        _seeMoreUI(viewModel, context)
      ],
    );
  }

  Widget _seeMoreUI(HomeViewModel viewModel, BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton.icon(
          onPressed: () => viewModel.navigateToAllView(),
          icon: const Icon(Icons.navigate_before_rounded),
          label: Text(
            AppStrings.seeMore,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _allWallUI(HomeViewModel model, BuildContext context) {
    final List<PopularWall> walls = model.isBusy
        ? List.generate(7, (index) => PopularWall())
        : model.originalWallList;
    return BuffySkeleton(
      enabled: model.isBusy,
      effect: pulseEffect(context),
      child: _allWallListViewUI(walls, model.controller),
    );
  }

  Widget _allWallListViewUI(
      List<PopularWall> walls, ScrollController controller) {
    return GridView.builder(
      shrinkWrap: true,
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: walls.length >= 20 ? 20 : walls.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final wall = walls[index];
        return BuffyImage(
          imageUrl: wall.compressUrl,
          isHot: wall.isHot,
          isPremium: wall.isPremium,
        );
      },
    );
  }

  Widget _colorsUI(HomeViewModel model, BuildContext context) {
    final List<Color> colors = model.isBusy
        ? List.generate(7, (index) => Colors.black)
        : model.data.hotColors;
    return SizedBox(
      height: 50,
      child: BuffySkeleton(
        enabled: model.isBusy,
        effect: pulseEffect(context),
        child: _colorsListViewUI(colors),
      ),
    );
  }

  Widget _colorsListViewUI(List<Color> colors) {
    return ListView.separated(
      separatorBuilder: (context, index) => horizontalSpaceSmall,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final Color color = colors[index];
        return Chip(
          label: const Text("          "),
          backgroundColor: color,
        );
      },
      itemCount: colors.length,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _chipsUI(HomeViewModel model, BuildContext context) {
    final List<String> chips = model.isBusy
        ? List.generate(7, (index) => 'Premium')
        : ["Trending", "Premium", ...model.data.trendingTags];
    return SizedBox(
      height: 50,
      child: BuffySkeleton(
        enabled: model.isBusy,
        effect: pulseEffect(context),
        child: _chipsListViewUI(chips),
      ),
    );
  }

  Widget _chipsListViewUI(List<String> chips) {
    return ListView.separated(
      separatorBuilder: (context, index) => horizontalSpaceSmall,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final chip = chips[index];
        return FilterChip.elevated(
          selected: index == 0,
          onSelected: (value) {},
          label: Text(chip,
              style: TextStyle(
                  color: index == 0
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground)),
        );
      },
      itemCount: chips.length,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _headerUI(String title, BuildContext context,
          {bool showViewIcon = false, VoidCallback? onTap}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Offstage(
                offstage: !showViewIcon,
                child: IconButton(
                    onPressed: onTap,
                    icon: const Icon(Icons.navigate_next_rounded)))
          ],
        ),
      );

  Widget _trendingUI(HomeViewModel model, BuildContext context) {
    final walls = model.isBusy
        ? List.generate(7, (index) => PopularWall())
        : model.trendingCollectionWalls;
    return SizedBox(
      height: 250,
      child: BuffySkeleton(
        enabled: model.isBusy,
        effect: pulseEffect(context),
        child: _listViewUI(walls),
      ),
    );
  }

  Widget _listViewUI(List<PopularWall> walls) {
    return ListView.separated(
      separatorBuilder: (context, index) => horizontalSpaceSmall,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: walls.length >= 10 ? 10 : walls.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final wall = walls[index];
        return SizedBox(
          width: 130,
          child: BuffyImage(
            imageUrl: wall.compressUrl,
            isHot: wall.isHot,
            isPremium: wall.isPremium,
          ),
        );
      },
    );
  }
}
