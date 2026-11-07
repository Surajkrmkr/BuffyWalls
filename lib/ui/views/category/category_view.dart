import 'package:flutter/material.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../home/home_viewmodel.dart';
import 'category_viewmodel.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  // Every tile is the same size so rows and gutters line up exactly; ads
  // sit between whole rows and never break the grid.
  static const double _tileH = 210;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
      viewModelBuilder: () => locator<CategoryViewModel>(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
      builder: (context, viewModel, child) {
        final onSurface = Theme.of(context).colorScheme.onSurface;
        final names = viewModel.categories.keys.toList();
        final width = MediaQuery.of(context).size.width;
        final tileW = (width - 40 - 12) / 2;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiwaliTitle(
                      child: Text(
                        'Categories',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 34,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                          color: onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      names.isEmpty
                          ? 'Loading the collection'
                          : '${names.length} styles, ${viewModel.totalWalls} wallpapers',
                      style: TextStyle(
                          fontSize: 14, color: onSurface.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: names.isEmpty
                  ? _skeleton(tileW)
                  : _grid(context, viewModel, names, tileW),
            ),
          ],
        );
      },
    );
  }

  Widget _skeleton(double tileW) {
    return ShimmerHost(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: Column(
          children: [
            const SkelBox(height: 92, radius: 22),
            const SizedBox(height: 12),
            for (var r = 0; r < 3; r++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkelBox(
                        width: tileW, height: _tileH, radius: 22),
                    const SizedBox(width: 12),
                    SkelBox(
                        width: tileW, height: _tileH, radius: 22),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, CategoryViewModel viewModel,
      List<String> names, double tileW) {
    final homeVm = locator<HomeViewModel>();
    final rows = <Widget>[];
    for (var i = 0; i < names.length; i += 2) {
      final r = i ~/ 2;
      if (r > 0 && r % 3 == 0) rows.add(const NativeFeedAd(compact: true));
      Widget tile(int idx, double h) {
        if (idx >= names.length) return SizedBox(width: tileW);
        final walls = viewModel.categories[names[idx]] ?? const <PopularWall>[];
        return CategoryTile(
          name: names[idx],
          count: walls.length,
          cover: walls.isEmpty ? null : walls.first,
          width: tileW,
          height: h,
          onTap: () => homeVm.navigateToCategoryDetailView(names[idx]),
        );
      }

      rows.add(
        Reveal(
          delay: Duration(milliseconds: 60 * (r > 3 ? 3 : r)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tile(i, _tileH),
                const SizedBox(width: 12),
                tile(i + 1, _tileH),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        if (homeVm.premiumWallList.isNotEmpty)
          Reveal(child: _PremiumTile(count: homeVm.premiumWallList.length)),
        ...rows,
        const SizedBox(height: 40),
      ],
    );
  }
}

class _PremiumTile extends StatelessWidget {
  final int count;
  const _PremiumTile({required this.count});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Pressable(
        scale: 0.985,
        onTap: locator<HomeViewModel>().navigateToPremiumView,
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: dark ? surfaceDark : surfaceLight,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: gold.withOpacity(0.55)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: premiumGradient),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: onGold, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count exclusive wallpapers',
                      style: TextStyle(
                          fontSize: 13, color: onSurface.withOpacity(0.55)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: onSurface.withOpacity(0.5)),
            ],
          ),
        ),
      ),
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
