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
      body: CustomScrollView(
        slivers: [
          SliverDetailHero(
            title: collection,
            cover: viewModel.heroWall,
            subtitle: viewModel.description,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Featured'),
                WallShelf(
                    walls: viewModel.featured, prefix: 'col_feat_$collection'),
                const NativeFeedAd(compact: true),
                SectionHeader(title: 'The full set', count: viewModel.walls.length),
                WallpaperGridSection(
                  walls: viewModel.explore.isNotEmpty
                      ? viewModel.explore
                      : viewModel.walls,
                  emptySubtitle: 'This collection is still growing. Check back soon.',
                ),
                if (viewModel.relatedCollections.isNotEmpty) ...[
                  const SectionHeader(title: 'Related collections'),
                  RelatedChipsRow(
                    labels: viewModel.relatedCollections,
                    onTap: (name) {
                      AnalyticsService.instance.logCollectionClick(name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CollectionDetailView(collection: name),
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
  CollectionDetailViewModel viewModelBuilder(BuildContext context) =>
      CollectionDetailViewModel();

  @override
  void onViewModelReady(CollectionDetailViewModel viewModel) {
    viewModel.init(collection);
  }
}
