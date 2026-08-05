import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';
import 'category_detail_viewmodel.dart';

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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BuffyAppBar(title: category, showBackBtn: true),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.heroWall != null)
                    CinematicHeroWidget(
                      wallpaper: viewModel.heroWall!,
                      overlayText: category,
                      animate: false,
                    ),
                  SectionHeader(title: "🔥 Trending in $category"),
                  WallpaperCarousel(walls: viewModel.trending),
                  SectionHeader(title: "🆕 Latest in $category"),
                  WallpaperCarousel(walls: viewModel.latest),
                  if (viewModel.relatedCollections.isNotEmpty) ...[
                    const SectionHeader(title: "📚 Collections"),
                    RelatedChipsRow(
                      labels: viewModel.relatedCollections,
                      onTap: (name) => locator<NavigationService>()
                          .navigateToCollectionDetailView(collection: name),
                    ),
                  ],
                  SectionHeader(
                    title: "🖼 All in $category",
                    count: viewModel.walls.length,
                  ),
                  WallpaperGridSection(
                    walls: viewModel.walls,
                  ),
                  if (viewModel.relatedCategories.isNotEmpty) ...[
                    const SectionHeader(title: "Related Categories"),
                    RelatedChipsRow(
                      labels: viewModel.relatedCategories,
                      onTap: (name) {
                        AnalyticsService.instance.logCategoryClick(name);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailView(category: name),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
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
