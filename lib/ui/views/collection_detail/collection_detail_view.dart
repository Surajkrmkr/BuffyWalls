import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

/// Editorial Collection landing page — Hero -> Description -> Featured ->
/// Explore -> Related Collections. No backend required; membership and
/// copy are both derived locally from the existing wallpaper dataset.
class CollectionDetailView extends StackedView<CollectionDetailViewModel> {
  final String collection;
  const CollectionDetailView({Key? key, required this.collection}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CollectionDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BuffyAppBar(title: collection, showBackBtn: true),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.heroWall != null)
                    CinematicHeroWidget(
                      wallpaper: viewModel.heroWall!,
                      overlayText: collection,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      viewModel.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SectionHeader(title: "✨ Featured Wallpapers"),
                  WallpaperCarousel(walls: viewModel.featured),
                  SectionHeader(title: "🖼 Explore", count: viewModel.walls.length),
                  WallpaperGridSection(
                    walls: viewModel.explore.isNotEmpty ? viewModel.explore : viewModel.walls,
                    emptySubtitle: "This collection is still growing — check back soon",
                  ),
                  if (viewModel.relatedCollections.isNotEmpty) ...[
                    const SectionHeader(title: "📚 Related Collections"),
                    RelatedChipsRow(
                      labels: viewModel.relatedCollections,
                      onTap: (name) {
                        AnalyticsService.instance.logCollectionClick(name);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CollectionDetailView(collection: name),
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
  CollectionDetailViewModel viewModelBuilder(BuildContext context) =>
      CollectionDetailViewModel();

  @override
  void onViewModelReady(CollectionDetailViewModel viewModel) {
    viewModel.init(collection);
  }
}
