import 'dart:ui';
import 'package:visibility_detector/visibility_detector.dart';
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
        // wallpaper). Cheap to call on every rebuild — internally a no-op
        // once it's already been shown.
        if (!viewModel.isBusy && !viewModel.hasError) {
          BuffyService.maybeShowFirstLaunchRatePopup(context);
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            controller: viewModel.controller,
            slivers: [
              const BuffyAppBar(
                showAnimatedText: false,
                showProIcon: true,
                title: AppStrings.buffyWallsTitle,
              ),
              SliverToBoxAdapter(
                child: viewModel.hasError
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            AppStrings.errorMessage,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                    : _bodyUI(viewModel, context),
              ),
              // Bottom spacing to prevent floating dock overlap
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
          floatingActionButton: AnimatedScale(
            scale: viewModel.showScrollToTop ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: viewModel.showScrollToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        // The frosted-white glass this was hardcoded to
                        // reads fine over the dark theme's backdrop, but
                        // disappears (near-white on near-white) in light
                        // mode — tint it dark there instead so the white
                        // arrow icon always has something to contrast
                        // against.
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.black.withOpacity(0.75),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.85),
                          width: 1.5,
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          viewModel.controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onViewModelReady: (viewModel) {
        viewModel.getAppVersion();
        viewModel.checkInAppUpdate();
        viewModel.getWalls();
        viewModel.setupScrollListener();
      },
      onDispose: (viewModel) {
        viewModel.logger.i("onDispose");
      },
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
    );
  }

  Widget _bodyUI(HomeViewModel viewModel, BuildContext context) {
    if (viewModel.isBusy) {
      return const HomeSkeletonWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Floating Search
        const FloatingSearch(),
        const SizedBox(height: 12),

        // 2. JSON Dynamic Banner
        if (viewModel.data.adBanners.isNotEmpty)
          CarouselBannerWidget(
            banners: viewModel.data.adBanners,
            onTap: viewModel.navigateToBanner,
          ),

        // 3. 🔥 Trending
        SectionImpressionTracker(
          sectionKey: 'trending',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: "🔥 Trending",
                onTap: viewModel.navigateToTrendingView,
              ),
              _trendingUI(viewModel, context),
            ],
          ),
        ),

        // Native Ad
        if (!BuffyService.isPro) ...[
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: NativeAdCard(aspectRatio: 3.4),
          ),
          const SizedBox(height: 16),
        ],

        // 4. 🆕 Latest Wallpapers
        SectionImpressionTracker(
          sectionKey: 'latest',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: "🆕 Latest Wallpapers",
                onTap: viewModel.navigateToAllView,
              ),
              _latestUI(viewModel, context),
            ],
          ),
        ),

        // 5. ✨ Wall of the Day
        if (viewModel.data.spotlight.isNotEmpty) ...[
          () {
            final spotlightId = viewModel.data.spotlight.first;
            final matchingWall = viewModel.originalWallList
                .firstWhereOrNull((w) => w.id == spotlightId);
            final spotlightText = viewModel.data.spotlighttext.isNotEmpty
                ? viewModel.data.spotlighttext.first
                : "Wall of the Day";
            if (matchingWall != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: "✨ Wall of the Day",
                  ),
                  CinematicHeroWidget(
                    wallpaper: matchingWall,
                    overlayText: spotlightText,
                    onTap: () => AnalyticsService.instance
                        .logWallOfDayClick(matchingWall.id.toString()),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }(),
        ],

        // 6. 🎨 Categories — real category cards, each a dedicated landing page
        SectionImpressionTracker(
          sectionKey: 'categories',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: "🎨 Categories"),
              _categoriesUI(viewModel, context),
            ],
          ),
        ),

        // 7. 🌈 Browse by Color — each color is a mini collection / detail page
        SectionImpressionTracker(
          sectionKey: 'colors',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: "🌈 Browse by Color"),
              ColorFilterCarousel(onTap: viewModel.navigateToColorDetailView),
            ],
          ),
        ),

        // 8. Daily Reward Banner — swaps to an editorial card once today's
        // milestone is reached (3/3), so the slot is never left empty.
        if (!BuffyService.isPro) ...[
          MonetizationService.milestoneReached
              ? const EditorialPromotionCard()
              : const RewardBanner(),
        ],

        // 9. 📚 Curated Collections — editorial collection pages
        if (viewModel.data.hotCollections.isNotEmpty) ...[
          SectionImpressionTracker(
            sectionKey: 'collections',
            onImpression: AnalyticsService.instance.logSectionImpression,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: "📚 Curated Collections",
                  onTap: viewModel.navigateToTrendingView,
                ),
                _collectionsCarouselUI(viewModel, context),
              ],
            ),
          ),
        ],

        // 10. ❤️ Recommended For You (local discovery engine)
        SectionImpressionTracker(
          sectionKey: 'recommended',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: _recommendedUI(viewModel, context),
        ),

        // Banner Ad below Recommended For You
        if (!BuffyService.isPro) ...[
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: BannerAdCard(adUnitId: AdMob.bannerAd2UnitId),
          ),
          const SizedBox(height: 16),
        ],

        // 11. Instant multi-select filters for the Explore grid below
        _filterBarUI(viewModel, context),
        const SizedBox(height: 12),

        // 12. Explore Wallpapers Grid
        SectionHeader(
          title: viewModel.hasActiveFilters
              ? "🖼 Filtered Results"
              : "🖼 Explore Wallpapers",
          count: viewModel.isBusy
              ? null
              : viewModel
                  .applyActiveFilters(viewModel.topWallpapersList)
                  .length,
        ),
        _allWallUI(viewModel, context, walls: viewModel.topWallpapersList),

        // 13. Adaptive Banner
        if (!BuffyService.isPro)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: AdsWidget(size: AdSize.banner),
          ),

        // 14. 🕒 Continue Browsing (New Section)
        SectionImpressionTracker(
          sectionKey: 'continue_browsing',
          onImpression: AnalyticsService.instance.logSectionImpression,
          child: _continueBrowsingUI(viewModel, context),
        ),

        // 14. More Wallpapers (Discovery CTA / Explore All)
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                "Explore 1,200+ Wallpapers",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: viewModel.navigateToAllView,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3603C6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Explore All",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openWall(PopularWall wall) {
    locator<NavigationService>().navigateToImageView(wall: wall);
  }

  Widget _trendingUI(HomeViewModel model, BuildContext context) {
    return WallpaperCarousel(
      walls: model.trendingCollectionWalls,
      onWallTap: (wall) {
        AnalyticsService.instance
            .logWallpaperClick(wall.id.toString(), 'trending');
        _openWall(wall);
      },
    );
  }

  Widget _latestUI(HomeViewModel model, BuildContext context) {
    return WallpaperCarousel(
      walls: model.originalWallList,
      onWallTap: (wall) {
        AnalyticsService.instance
            .logWallpaperClick(wall.id.toString(), 'latest');
        _openWall(wall);
      },
    );
  }

  Widget _categoriesUI(HomeViewModel model, BuildContext context) {
    final names = model.categories.keys.toList();
    if (names.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final name = names[index];
          final count = model.categories[name]?.length ?? 0;
          return HomeCategoryCard(
            categoryName: name,
            count: count,
            onTap: () => model.navigateToCategoryDetailView(name),
          );
        },
      ),
    );
  }

  Widget _collectionsCarouselUI(HomeViewModel model, BuildContext context) {
    final collections = model.data.hotCollections;
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: collections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final tag = collections[index];
          return GestureDetector(
            onTap: () => model.navigateToCollectionDetailView(tag),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.08),
                  width: 1.5,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_motion_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _recommendedUI(HomeViewModel model, BuildContext context) {
    final walls = model.recommendedWalls;
    if (walls.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "❤️ Recommended For You"),
        WallpaperCarousel(
          walls: walls,
          onWallTap: (wall) {
            AnalyticsService.instance
                .logRecommendationClick(wall.id.toString());
            _openWall(wall);
          },
        ),
      ],
    );
  }

  Widget _continueBrowsingUI(HomeViewModel model, BuildContext context) {
    final walls = BuffyService.sessionHistory;
    if (walls.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "🕒 Continue Browsing"),
        WallpaperCarousel(
          walls: walls,
          onWallTap: (wall) {
            AnalyticsService.instance
                .logContinueBrowsingClick(wall.id.toString());
            _openWall(wall);
          },
        ),
      ],
    );
  }

  /// Instant multi-select filter bar for the Explore Wallpapers grid below
  /// (tag/category chips + color-dot chips, AND-combined). Labeled and
  /// given its own "Clear" action so it doesn't read as a continuation of
  /// the "Recommended For You" carousel above it.
  Widget _filterBarUI(HomeViewModel model, BuildContext context) {
    final List<String> tagChips = [
      AppStrings.premiumTitle,
      ...model.data.trendingTags,
    ];

    final filterItems = <_QuickFilterData>[];

    for (final chip in tagChips) {
      filterItems.add(_QuickFilterData(
        key: ValueKey('tag_$chip'),
        label: chip,
        isSelected: model.activeTagFilters.contains(chip),
        onTap: () => model.toggleTagFilter(chip),
      ));
    }

    for (final colorName in HomeViewModel.namedColors) {
      final color = colorName.toLowerCase().toColor();
      final isSelected =
          model.activeColorFilters.any((c) => c.toARGB32() == color.toARGB32());
      filterItems.add(_QuickFilterData(
        key: ValueKey('color_$colorName'),
        label: colorName,
        dotColor: color,
        isSelected: isSelected,
        onTap: () => model.toggleColorFilter(color),
      ));
    }

    filterItems.sort((a, b) {
      if (a.isSelected && !b.isSelected) return -1;
      if (!a.isSelected && b.isSelected) return 1;
      return 0;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Quick Filters",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (model.hasActiveFilters)
                GestureDetector(
                  onTap: model.clearFilters,
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: filterItems.length,
            itemBuilder: (context, index) {
              final item = filterItems[index];
              return _filterChip(
                context,
                key: item.key,
                label: item.label,
                isSelected: item.isSelected,
                dotColor: item.dotColor,
                onTap: item.onTap,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(BuildContext context,
      {Key? key,
      required String label,
      required bool isSelected,
      required VoidCallback onTap,
      Color? dotColor}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allWallUI(HomeViewModel model, BuildContext context,
      {List<PopularWall>? walls}) {
    final wallList = model.applyActiveFilters(walls ?? model.originalWallList);

    return WallpaperGridSection(
      walls: wallList,
      emptySubtitle: "Try clearing a filter or exploring another category",
    );
  }
}

class FloatingSearch extends StatelessWidget {
  const FloatingSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => locator<NavigationService>().navigateToSearchView(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search wallpapers...',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tapping a color opens its dedicated [ColorDetailView] — colors are
/// treated as mini editorial collections, not just an in-place filter (the
/// instant multi-select color filter lives separately in the filter bar
/// above the Explore grid).
class ColorFilterCarousel extends StatelessWidget {
  final void Function(Color color) onTap;

  const ColorFilterCarousel({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const colors = HomeViewModel.namedColors;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final colorName = colors[index];
          final colorValue = colorName.toLowerCase().toColor();

          return GestureDetector(
            onTap: () => onTap(colorValue),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.08),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorValue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    colorName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CinematicHeroWidget extends StatefulWidget {
  final PopularWall wallpaper;
  final String overlayText;
  final VoidCallback? onTap;
  final bool animate;
  const CinematicHeroWidget({
    super.key,
    required this.wallpaper,
    required this.overlayText,
    this.onTap,
    this.animate = true,
  });

  @override
  State<CinematicHeroWidget> createState() => _CinematicHeroWidgetState();
}

class _CinematicHeroWidgetState extends State<CinematicHeroWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _kenBurnsController;
  Animation<double>? _kenBurnsAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _kenBurnsController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      );
      _kenBurnsAnimation = CurvedAnimation(
        parent: _kenBurnsController!,
        curve: Curves.easeInOut,
      );
      _kenBurnsController!.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _kenBurnsController?.dispose();
    super.dispose();
  }

  // Overscale used while panning, and how far (as a fraction of the
  // rendered box) we let the pan travel. `FractionalTranslation`'s offset
  // is relative to the box's own (unscaled) layout size, but the visual
  // headroom created by wrapping it in `Transform.scale` is
  // `(scale - 1) / 2` of that same box — so the *effective* on-screen
  // shift is `_panAmplitude * _kenBurnsScale`. Keeping that comfortably
  // under the headroom (here: ~55%) is what stops the image at a safe
  // point instead of panning past its own edge and exposing the card
  // background underneath.
  static const double _kenBurnsScale = 1.15;
  static const double _panAmplitude = 0.035;

  @override
  Widget build(BuildContext context) {
    // The animated Spotlight pan needs real detail to reveal as it moves,
    // so it uses the full wallpaper at full resolution. The static
    // category banner just needs to appear fast, so it uses the
    // compressed preview instead (same idea as grid thumbnails).
    final image = widget.animate
        ? CacheImage(imageUrl: widget.wallpaper.imageUrl, fullView: true)
        : CacheImage(
            imageUrl: widget.wallpaper.compressUrl.isNotEmpty
                ? widget.wallpaper.compressUrl
                : widget.wallpaper.imageUrl,
            fullView: false,
          );

    final Widget imageLayer = widget.animate
        ? RepaintBoundary(
            child: AnimatedBuilder(
              animation: _kenBurnsAnimation!,
              builder: (context, child) {
                final val = _kenBurnsAnimation!.value;
                // Pans the wallpaper vertically top -> bottom, then
                // `repeat(reverse: true)` sends it back bottom -> top.
                final dy = -_panAmplitude + (val * _panAmplitude * 2);

                return Transform.scale(
                  scale: _kenBurnsScale,
                  child: FractionalTranslation(
                    translation: Offset(0, dy),
                    child: child,
                  ),
                );
              },
              child: image,
            ),
          )
        : image;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: VisibilityDetector(
          key: const Key('spotlight_visibility'),
          onVisibilityChanged: (info) {
            if (!widget.animate || !mounted) return;
            if (info.visibleFraction > 0.05) {
              if (!_kenBurnsController!.isAnimating) {
                _kenBurnsController!.repeat(reverse: true);
              }
            } else {
              if (_kenBurnsController!.isAnimating) {
                _kenBurnsController!.stop();
              }
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
                locator<NavigationService>().navigateToImageView(
                  wall: widget.wallpaper,
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ken Burns Panning Image (or static, per widget.animate)
                  imageLayer,

                  // Subtly dark gradient overlay for text readability (20-30% opacity)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),

                  // Center Aligned Editorial Text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        widget.overlayText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSkeletonWidget extends StatelessWidget {
  const HomeSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar Skeleton
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Skeletonizer(
              enabled: true,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Spotlight Hero Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Skeletonizer(
                enabled: true,
                child: Text("✨ Spotlight",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AspectRatio(
              aspectRatio: 1.4,
              child: Skeletonizer(
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Trending Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Skeletonizer(
                enabled: true,
                child: Text("🔥 Trending",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => Skeletonizer(
                enabled: true,
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. Latest Wallpapers Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Skeletonizer(
                enabled: true,
                child: Text("🆕 Latest Wallpapers",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => Skeletonizer(
                enabled: true,
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 5. Grid Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Skeletonizer(
                enabled: true,
                child: Text("🖼 Explore Wallpapers",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 12),
          const ShimmerGrid(),
        ],
      ),
    );
  }
}

class _QuickFilterData {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? dotColor;
  final Key key;

  _QuickFilterData({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.key,
    this.dotColor,
  });
}

