import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
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
      onViewModelReady: (viewModel) {
        viewModel.getAppVersion();
        viewModel.checkInAppUpdate();
        viewModel.getWalls();
      },
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
        PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: _chipWiseUI(context, viewModel)),
      ],
    );
  }

  Widget _chipWiseUI(BuildContext context, HomeViewModel viewModel) {
    switch (viewModel.selectedFilter) {
      case AppStrings.trendingTitle:
        return _trendingChipUI(context, viewModel);
      case AppStrings.premiumTitle:
        return _premiumChipUI(context, viewModel);
      default:
        return commonChipUI(context, viewModel);
    }
  }

  Widget _premiumChipUI(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
        _allWallUI(viewModel, context, showPremiumOnly: true),
        _seeMoreUI(viewModel, context, onTap: viewModel.navigateToPremiumView)
      ],
    );
  }

  Widget commonChipUI(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
        _allWallUI(viewModel, context, showCommonOnly: true),
        _seeMoreUI(viewModel, context, onTap: viewModel.navigateToCommonTagView)
      ],
    );
  }

  Column _trendingChipUI(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
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
        _seeMoreUI(
          viewModel,
          context,
          onTap: viewModel.navigateToAllView,
        ),
      ],
    );
  }

  Widget _seeMoreUI(HomeViewModel viewModel, BuildContext context,
      {required Function() onTap}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton.icon(
          onPressed: onTap,
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

  Widget _allWallUI(HomeViewModel model, BuildContext context,
      {bool showPremiumOnly = false, bool showCommonOnly = false}) {
    final List<PopularWall> walls = model.isBusy
        ? List.generate(7, (index) => PopularWall())
        : showPremiumOnly
            ? model.premiumWallList
            : showCommonOnly
                ? model.filterWalls[model.selectedFilter]!
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
        return BuffyImage(wall: wall);
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
        child: _colorsListViewUI(colors,
            onSelected: model.navigateToCommonColorView),
      ),
    );
  }

  Widget _colorsListViewUI(List<Color> colors,
      {required Function(Color) onSelected}) {
    return ListView.separated(
      separatorBuilder: (context, index) => horizontalSpaceSmall,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final Color color = colors[index];
        return ActionChip(
            label: const Text("          "),
            backgroundColor: color,
            onPressed: () => onSelected(color),
            shape: const RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(15))));
      },
      itemCount: colors.length,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _chipsUI(HomeViewModel model, BuildContext context) {
    final List<String> chips = model.isBusy
        ? List.generate(7, (index) => AppStrings.buffyWallsTitle)
        : [
            AppStrings.trendingTitle,
            AppStrings.premiumTitle,
            ...model.data.trendingTags
          ];
    return SizedBox(
      height: 50,
      child: BuffySkeleton(
        enabled: model.isBusy,
        effect: pulseEffect(context),
        child: _chipsListViewUI(chips, model.selectedFilter,
            onSelected: model.onSelectFilter),
      ),
    );
  }

  Widget _chipsListViewUI(List<String> chips, String selectedChip,
      {required Function(String) onSelected}) {
    return ListView.separated(
      separatorBuilder: (context, index) => horizontalSpaceSmall,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final chip = chips[index];
        return FilterChip.elevated(
          selected: chip == selectedChip,
          onSelected: (_) => onSelected(chip),
          label: Text(chip,
              style: TextStyle(
                  color: chip == selectedChip
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
        return SizedBox(width: 130, child: BuffyImage(wall: wall));
      },
    );
  }
}
