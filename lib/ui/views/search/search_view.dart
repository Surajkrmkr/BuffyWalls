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
          const AdsWidget()
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
          if (viewModel.textEditingController.text.isEmpty)
            ..._popularWordsUI(viewModel, context),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: walls.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final wall = walls[index];
        return BuffyImage(wall: wall);
      },
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
                        color: Theme.of(context).colorScheme.onBackground)),
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
