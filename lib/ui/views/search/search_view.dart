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
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: BuffyTextField(
                  onChanged: viewModel.onSearch,
                  controller: viewModel.textEditingController,
                  onClear: viewModel.onClear,
                  onSubmitted: viewModel.onSubmitted,
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
    // The chip/header content gets its own horizontal padding, but the
    // wallpaper grid does NOT sit inside it — `WallpaperGridSection`
    // already applies its own 16px horizontal padding (same as every
    // other grid in the app), so nesting it inside this 15px padding too
    // was stacking both and making the cards visibly narrower here than
    // anywhere else.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!viewModel.hasQuery) ...[
                const AdsWidget(
                  bottomPadding: 0,
                  adUnitId: AdMob.bannerAd2UnitId,
                ),
                verticalSpaceSmall,
                if (viewModel.recentSearches.isNotEmpty)
                  ..._recentSearchesUI(viewModel, context),
                _colorsUI(viewModel, context),
                ..._popularWordsUI(viewModel, context),
              ] else if (viewModel.suggestions.isNotEmpty) ...[
                ..._suggestionsUI(viewModel, context),
              ],
            ],
          ),
        ),
        if (viewModel.showNoResults)
          _noResultsUI(viewModel, context)
        else ...[
          const SizedBox(height: 20),
          _wallListViewUI(viewModel.pageWiseWalls),
        ],
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
    );
  }

  List<Widget> _recentSearchesUI(SearchViewModel viewModel, BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recent Searches",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: viewModel.clearRecentSearches,
            child: Text(
              "Clear",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      verticalSpaceSmall,
      Wrap(
        runSpacing: 10,
        spacing: 10,
        children: viewModel.recentSearches
            .map((word) => ActionChip.elevated(
                  onPressed: () => viewModel.onRecentSearchSelected(word),
                  avatar: const Icon(Icons.history_rounded, size: 16),
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
      ),
      verticalSpaceSmall,
    ];
  }

  List<Widget> _suggestionsUI(SearchViewModel viewModel, BuildContext context) {
    return [
      Wrap(
        runSpacing: 10,
        spacing: 10,
        children: viewModel.suggestions
            .map((word) => ActionChip.elevated(
                  onPressed: () => viewModel.onSuggestionSelected(word),
                  avatar: const Icon(Icons.search_rounded, size: 16),
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
      ),
      verticalSpaceSmall,
    ];
  }

  Widget _noResultsUI(SearchViewModel viewModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
          child: Text(
            "No results for \"${viewModel.textEditingController.text.trim()}\" — try these instead",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        _wallListViewUI(viewModel.noResultSuggestions),
      ],
    );
  }

  List<Widget> _popularWordsUI(
      SearchViewModel viewModel, BuildContext context) {
    return [
      Text(
        "Trending Searches",
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      verticalSpaceSmall,
      _chipsUI(viewModel, context),
      verticalSpaceSmall,
    ];
  }

  // Search already shows only the current query's results in one shot (no
  // internal pagination beyond scroll-to-load), but still uses the shared
  // grid so ad density/style matches every other wallpaper grid in the app.
  Widget _wallListViewUI(List<PopularWall> walls) {
    return WallpaperGridSection(walls: walls, pageSize: 1000000);
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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

  @override
  void onDispose(SearchViewModel viewModel) {
    viewModel.controller.dispose();
    viewModel.textEditingController.dispose();
    super.onDispose(viewModel);
  }
}
