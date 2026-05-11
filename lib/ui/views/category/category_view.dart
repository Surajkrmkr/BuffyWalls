import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'category_viewmodel.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
        viewModelBuilder: () => locator<CategoryViewModel>(),
        disposeViewModel: false,
        fireOnViewModelReadyOnce: true,
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: viewModel.categories.length,
            child: _TabAnalyticsListener(
              categoryNames: viewModel.categories.keys.toList(),
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  BuffyAppBar(
                    title: AppStrings.collectionTitle,
                    categories:
                        viewModel.categories.entries.map((e) => e.key).toList(),
                  )
                ],
                body: viewModel.hasError
                    ? const Center(
                        child: Text(AppStrings.errorMessage),
                      )
                    : _bodyUI(viewModel, context),
              ),
            ),
          );
        });
  }

  Widget _bodyUI(CategoryViewModel viewModel, BuildContext context) {
    return TabBarView(
      children: viewModel.categories.entries
          .map((category) => ListView(
                children: [
                  _wallListViewUI(category.value),
                  Center(child: _seeMoreUI(category.key, viewModel, context)),
                ],
              ))
          .toList(),
    );
  }

  Widget _seeMoreUI(
      String category, CategoryViewModel viewModel, BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton.icon(
          onPressed: () => viewModel.navigateToMoreView(category),
          icon: const Icon(Icons.navigate_before_rounded),
          label: Text(
            AppStrings.seeMore,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.normal),
          )),
    );
  }

  Widget _wallListViewUI(List<PopularWall> walls) {
    final int count = walls.length >= 39 ? 39 : walls.length;
    final List<Widget> children = [];

    for (int i = 0; i < count; i += 3) {
      final rowIndex = i ~/ 3;
      if (rowIndex > 0 && rowIndex % 4 == 0) {
        children.add(const SizedBox(height: 10));
        children.add(const GridAdWidget());
      }
      if (rowIndex > 0) children.add(const SizedBox(height: 10));
      children.add(_wallRowUI(
        walls[i],
        i + 1 < count ? walls[i + 1] : null,
        i + 2 < count ? walls[i + 2] : null,
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
          child: AspectRatio(aspectRatio: 0.6, child: BuffyImage(wall: left)),
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

class _TabAnalyticsListener extends StatefulWidget {
  final List<String> categoryNames;
  final Widget child;

  const _TabAnalyticsListener(
      {required this.categoryNames, required this.child});

  @override
  State<_TabAnalyticsListener> createState() => _TabAnalyticsListenerState();
}

class _TabAnalyticsListenerState extends State<_TabAnalyticsListener> {
  TabController? _tabController;
  int _previousIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController?.removeListener(_onTabChanged);
    _tabController = DefaultTabController.of(context);
    _tabController?.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final controller = _tabController;
    if (controller == null || controller.indexIsChanging) return;
    final index = controller.index;
    if (index == _previousIndex) return;
    _previousIndex = index;
    if (index < widget.categoryNames.length) {
      AnalyticsService.instance
          .logCategoryTabChanged(index, widget.categoryNames[index]);
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
