import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'search_viewmodel.dart';

class SearchView extends StackedView<SearchViewModel> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: CustomScrollView(controller: viewModel.controller, slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: BuffyTextField(
                  onChanged: viewModel.onSearch,
                  controller: viewModel.textEditingController,
                  onClear: viewModel.onClear,
                ),
              )),
              SliverToBoxAdapter(child: _bodyUI(viewModel, context)),
            ]),
          ),
          verticalSpaceSmall,
          const AdsWidget(
            adUnitId: AdMob.bannerAd2UnitId,
          )
        ],
      )),
    );
  }

  Widget _bodyUI(SearchViewModel viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (viewModel.textEditingController.text.isEmpty) ...[
            const AdsWidget(
              bottomPadding: 0,
              adUnitId: AdMob.bannerAd2UnitId,
            ),
            verticalSpaceSmall,
            _colorsUI(viewModel, context),
            ..._popularWordsUI(viewModel, context)
          ],
          _wallListViewUI(viewModel.pageWiseWalls),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: viewModel.isBusy,
              child: const SizedBox.square(
                  dimension: 30,
                  child: Center(child: CircularProgressIndicator())),
            ),
          ),
          verticalSpaceSmall
        ],
      ),
    );
  }

  List<Widget> _popularWordsUI(
      SearchViewModel viewModel, BuildContext context) {
    return [
      Text(
        AppStrings.popularWords,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      verticalSpaceSmall,
      _chipsUI(viewModel, context),
    ];
  }

  Widget _wallListViewUI(List<PopularWall> walls) {
    final List<Widget> children = [];
    int adCount = 0;
    for (int i = 0; i < walls.length; i += 3) {
      if (i > 0) children.add(const SizedBox(height: 10));
      children.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
                aspectRatio: 0.5, child: BuffyImage(wall: walls[i])),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: i + 1 < walls.length
                ? AspectRatio(
                    aspectRatio: 0.5, child: BuffyImage(wall: walls[i + 1]))
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: i + 2 < walls.length
                ? AspectRatio(
                    aspectRatio: 0.5, child: BuffyImage(wall: walls[i + 2]))
                : const SizedBox.shrink(),
          ),
        ],
      ));
      final rendered = i + 3;
      if (rendered >= (adCount + 1) * 9 && rendered < walls.length) {
        adCount++;
        children.add(const SizedBox(height: 10));
        children.add(const GridAdWidget());
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: children),
    );
  }

  Widget _colorsUI(SearchViewModel viewModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.searchByColors,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        verticalSpaceSmall,
        SizedBox(
          height: 50,
          child: ListView.separated(
            separatorBuilder: (context, index) => horizontalSpaceSmall,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: viewModel.hotColors.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final color = viewModel.hotColors[index];
              return ActionChip(
                  label: const Text("          "),
                  backgroundColor: color,
                  onPressed: () => viewModel.navigateToCommonColorView(color),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(style: BorderStyle.none),
                      borderRadius: BorderRadius.all(Radius.circular(15))));
            },
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Widget _chipsUI(SearchViewModel viewModel, BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: viewModel.popularWords
          .map((word) => ActionChip.elevated(
                onPressed: () => viewModel.onWordSelected(word),
                color: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.background),
                shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                label: Text(word,
                    style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground)
                        .copyWith(fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }

  @override
  SearchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchViewModel();

  @override
  void onViewModelReady(SearchViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.init();
  }
}
