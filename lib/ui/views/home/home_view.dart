import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) {
        // One-time first-ever-open prompt (rate + unlock a free Pro
        // wallpaper). Internally a no-op once it has been shown.
        if (!viewModel.isBusy && !viewModel.hasError) {
          BuffyService.maybeShowFirstLaunchRatePopup(context);
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            controller: viewModel.controller,
            slivers: [
              SliverToBoxAdapter(
                child: (viewModel.hasError || viewModel.loadFailed)
                    ? _error(context, viewModel)
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 420),
                        switchInCurve: Curves.easeOut,
                        child: viewModel.isBusy
                            ? const _HomeSkeleton(key: ValueKey('skeleton'))
                            : _Content(
                                key: const ValueKey('content'),
                                viewModel: viewModel,
                              ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          floatingActionButton: _ScrollToTop(viewModel: viewModel),
        );
      },
      onViewModelReady: (viewModel) {
        viewModel.getAppVersion();
        viewModel.checkInAppUpdate();
        viewModel.getWalls();
        viewModel.setupScrollListener();
      },
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
    );
  }

  Widget _error(BuildContext context, HomeViewModel viewModel) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        const GalleryHeader(),
        const SizedBox(height: 120),
        Icon(Icons.cloud_off_rounded,
            size: 44, color: onSurface.withOpacity(0.35)),
        const SizedBox(height: 18),
        Text(
          "Couldn't load wallpapers",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Check your connection and try again.',
          style: TextStyle(fontSize: 14, color: onSurface.withOpacity(0.5)),
        ),
        const SizedBox(height: 22),
        Pressable(
          onTap: viewModel.getWalls,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
            decoration: BoxDecoration(
              color: onSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Try again',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScrollToTop extends StatelessWidget {
  final HomeViewModel viewModel;
  const _ScrollToTop({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedScale(
      scale: viewModel.showScrollToTop ? 1 : 0,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutBack,
      child: FloatingActionButton.small(
        heroTag: 'home_top',
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: dark ? surfaceDark : surfaceLight,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        onPressed: () => viewModel.controller.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        ),
        child: const Icon(Icons.arrow_upward_rounded),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded feed
// ---------------------------------------------------------------------------

class _Content extends StatelessWidget {
  final HomeViewModel viewModel;
  const _Content({super.key, required this.viewModel});

  List<FeaturedItem> _featured() {
    final out = <FeaturedItem>[];
    final seen = <int>{};
    final d = viewModel.data;
    for (var i = 0; i < d.spotlight.length; i++) {
      final wall = viewModel.originalWallList
          .firstWhereOrNull((w) => w.id == d.spotlight[i]);
      if (wall == null || !seen.add(wall.id)) continue;
      final kicker = i < d.spotlighttext.length && d.spotlighttext[i].isNotEmpty
          ? d.spotlighttext[i]
          : 'Wall of the day';
      out.add(FeaturedItem(wall, kicker));
    }
    // The rest of the hero rotates daily: a day-seeded pick from the top of
    // the list, so it changes every day without a content update.
    final now = DateTime.now();
    final pool = viewModel.topWallpapersList.take(40).toList()
      ..shuffle(Random(now.year * 1000 + now.difference(DateTime(now.year)).inDays));
    for (final wall in pool) {
      if (out.length >= 6) break;
      if (seen.add(wall.id)) out.add(FeaturedItem(wall, 'Featured'));
    }
    return out;
  }

  PopularWall? _collectionCover(String name) =>
      viewModel.wallsForCollection(name).firstOrNull;

  Widget _track(String key, Widget child) => SectionImpressionTracker(
        sectionKey: key,
        onImpression: AnalyticsService.instance.logSectionImpression,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    final isPro = BuffyService.isPro;
    final nav = locator<NavigationViewModel>();
    final filterLabels = [AppStrings.premiumTitle, ...vm.data.trendingTags];
    final exploreWalls = vm.applyActiveFilters(vm.topWallpapersList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GalleryHeader(),
        const SearchPill(),
        const SizedBox(height: 22),
        Reveal(child: FeaturedCarousel(items: _featured())),
        _track(
          'categories',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Categories',
                subtitle: 'Every style, sorted',
                onTap: () => nav.setIndex(1),
              ),
              CategoryShelf(
                categories: vm.categories,
                onTap: vm.navigateToCategoryDetailView,
              ),
            ],
          ),
        ),
        if (vm.data.adBanners.isNotEmpty) ...[
          const SizedBox(height: 26),
          CarouselBannerWidget(
            banners: vm.data.adBanners,
            onTap: vm.navigateToBanner,
          ),
        ],
        if (vm.premiumWallList.isNotEmpty)
          _track(
            'premium',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Premium',
                  subtitle: isPro
                      ? 'Your exclusive collection'
                      : 'Exclusive art. Unlock with Pro or a short video.',
                  onTap: vm.navigateToPremiumView,
                ),
                WallShelf(walls: vm.premiumWallList, prefix: 'premium'),
                if (!isPro)
                  Reveal(
                    child: MonetizationService.milestoneReached
                        ? const EditorialPromotionCard()
                        : const RewardBanner(),
                  ),
              ],
            ),
          ),
        _track(
          'trending',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Trending',
                subtitle: 'What everyone is applying right now',
                onTap: vm.navigateToTrendingView,
              ),
              WallShelf(
                walls: vm.trendingCollectionWalls,
                prefix: 'trending',
                onTap: (wall) {
                  AnalyticsService.instance
                      .logWallpaperClick(wall.id.toString(), 'trending');
                  locator<NavigationService>().navigateToImageView(wall: wall);
                },
              ),
            ],
          ),
        ),
        const NativeFeedAd(),
        if (vm.data.hotCollections.isNotEmpty)
          _track(
            'collections',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Collections',
                  subtitle: 'Hand-picked sets that belong together',
                ),
                CollectionShelf(
                  names: vm.data.hotCollections,
                  coverFor: _collectionCover,
                  onTap: vm.navigateToCollectionDetailView,
                ),
              ],
            ),
          ),
        _track(
          'latest',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Just added',
                subtitle: 'Fresh from the studio',
                onTap: vm.navigateToAllView,
              ),
              WallShelf(
                walls: vm.originalWallList,
                prefix: 'latest',
                onTap: (wall) {
                  AnalyticsService.instance
                      .logWallpaperClick(wall.id.toString(), 'latest');
                  locator<NavigationService>().navigateToImageView(wall: wall);
                },
              ),
            ],
          ),
        ),
        _track(
          'colors',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Browse by colour',
                subtitle: 'Find a wallpaper that matches your mood',
              ),
              ColorSwatchRow(onTap: vm.navigateToColorDetailView),
            ],
          ),
        ),
        const NativeFeedAd(),
        if (vm.recommendedWalls.isNotEmpty)
          _track(
            'recommended',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Picked for you',
                  subtitle: 'Based on what you have saved and applied',
                ),
                WallShelf(
                  walls: vm.recommendedWalls,
                  prefix: 'reco',
                  onTap: (wall) {
                    AnalyticsService.instance
                        .logRecommendationClick(wall.id.toString());
                    locator<NavigationService>()
                        .navigateToImageView(wall: wall);
                  },
                ),
              ],
            ),
          ),
        SectionHeader(
          title: vm.hasActiveFilters ? 'Filtered' : 'Explore',
          count: exploreWalls.length,
        ),
        FilterPills(
          labels: filterLabels,
          selected: vm.activeTagFilters,
          onTap: vm.toggleTagFilter,
        ),
        const SizedBox(height: 18),
        WallpaperGridSection(
          walls: exploreWalls,
          emptySubtitle: 'Try clearing a filter or exploring another category',
        ),
        if (BuffyService.sessionHistory.isNotEmpty)
          _track(
            'continue_browsing',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Continue browsing'),
                WallShelf(
                  walls: BuffyService.sessionHistory,
                  prefix: 'history',
                  onTap: (wall) {
                    AnalyticsService.instance
                        .logContinueBrowsingClick(wall.id.toString());
                    locator<NavigationService>()
                        .navigateToImageView(wall: wall);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton — mirrors the feed above with the same dimensions.
// ---------------------------------------------------------------------------

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ShimmerHost(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GalleryHeader(),
          const SearchPill(),
          const SizedBox(height: 22),
          SizedBox(
            height: kFeaturedH,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (w * (1 - kFeaturedFraction)) / 2 + 6),
              child: const SkelBox(radius: 28),
            ),
          ),
          const SizedBox(height: 22),
          const SkelTitle(),
          const SkelShelf(itemW: kCatTileW, itemH: kCatTileH, radius: 22),
          const SkelTitle(),
          const SkelShelf(),
          const SkelTitle(),
          const SkelShelf(),
        ],
      ),
    );
  }
}
