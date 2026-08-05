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
                  const SizedBox(height: 16),
                  _wallListViewUI(category.value),
                  Center(child: _seeMoreUI(category.key, viewModel, context)),
                  const SizedBox(height: 100),
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
    final capped = walls.length > 39 ? walls.sublist(0, 39) : walls;
    return WallpaperGridSection(walls: capped);
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
