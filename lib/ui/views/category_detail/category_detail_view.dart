import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

/// Dedicated Category landing page — Hero -> Trending -> Latest -> Explore
/// All -> Related Categories. Reached by tapping a category card on Home
/// (categories are discovery gateways, not just an in-place Home filter).
class CategoryDetailView extends StackedView<CategoryDetailViewModel> {
  final String category;
  const CategoryDetailView({Key? key, required this.category}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CategoryDetailViewModel viewModel,
    Widget? child,
  ) {
    final premiumCount = viewModel.walls.where((w) => w.isPremium).length;
    final homeVm = locator<HomeViewModel>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDetailHero(
            title: category,
            cover: viewModel.heroWall,
            subtitle: premiumCount > 0
                ? '${viewModel.walls.length} wallpapers  ·  $premiumCount premium'
                : '${viewModel.walls.length} wallpapers',
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Trending in $category'),
                WallShelf(
                    walls: viewModel.trending, prefix: 'cat_trending_$category'),
                const NativeFeedAd(compact: true),
                if (viewModel.relatedCollections.isNotEmpty) ...[
                  const SectionHeader(title: 'Collections'),
                  RelatedChipsRow(
                    labels: viewModel.relatedCollections,
                    onTap: (name) => locator<NavigationService>()
                        .navigateToCollectionDetailView(collection: name),
                  ),
                ],
                SectionHeader(
                  title: 'All in $category',
                  count: viewModel.walls.length,
                ),
                WallpaperGridSection(walls: viewModel.walls),
                if (viewModel.relatedCategories.isNotEmpty) ...[
                  const SectionHeader(title: 'More to explore'),
                  CategoryShelf(
                    categories: {
                      for (final name in viewModel.relatedCategories)
                        name: homeVm.categories[name] ?? const <PopularWall>[]
                    },
                    onTap: (name) {
                      AnalyticsService.instance.logCategoryClick(name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryDetailView(category: name),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  CategoryDetailViewModel viewModelBuilder(BuildContext context) =>
      CategoryDetailViewModel();

  @override
  void onViewModelReady(CategoryDetailViewModel viewModel) {
    viewModel.init(category);
  }
}
