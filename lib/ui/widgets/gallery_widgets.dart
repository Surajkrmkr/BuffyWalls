import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'widget_export.dart';

// Shared dimensions. Skeletons are built from these same numbers, so the
// loading state always lines up with the loaded one.
const double kShelfCardW = 140;
const double kShelfCardH = 236;
const double kFeaturedH = 470;
const double kFeaturedFraction = 0.86;
const double kCatTileW = 152;
const double kCatTileH = 204;
const double kCollectionW = 232;
const double kCollectionH = 128;

/// Opens a wallpaper, asking for Pro / a rewarded unlock first if it is
/// premium and still locked today. Same rules as tapping a [BuffyImage].
Future<void> openWall(PopularWall wall, {VoidCallback? onOpen}) async {
  final unlocked =
      wall.isPremium && MonetizationService.isUnlockedToday(wall.id);
  if (!BuffyService.isPro && wall.isPremium && !unlocked) {
    final response = await locator<DialogService>().showCustomDialog(
      variant: DialogType.pro,
      barrierDismissible: false,
      data: {'wallId': wall.id},
    );
    if (response?.confirmed != true) return;
  }
  onOpen?.call();
  locator<NavigationService>().navigateToImageView(wall: wall);
}

/// Straight to the BuffyWalls Pro listing on Play Store, no dialog in between.
void openProDialog() {
  AnalyticsService.instance.logSettingsTapped('go_pro_chip');
  openLink(Links.buffyPaid);
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class GalleryHeader extends StatelessWidget {
  const GalleryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiwaliLights(
                  child: Text(
                    'BuffyWalls',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 26,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Wallpapers, in 4K',
                  style: TextStyle(
                    fontSize: 12.5,
                    letterSpacing: 0.2,
                    color: onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (!BuffyService.isPro) ...[
            Pressable(
              onTap: openProDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: premiumGradient),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        size: 16, color: onGold),
                    SizedBox(width: 5),
                    Text(
                      'Go Pro',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: onGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Pressable(
            scale: 0.9,
            onTap: () => locator<NavigationService>().navigateToSettingsView(),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(left: 6, right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: onSurface.withOpacity(0.14)),
              ),
              child: Icon(Icons.settings_outlined,
                  size: 21, color: onSurface.withOpacity(0.85)),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPill extends StatelessWidget {
  const SearchPill({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Pressable(
        scale: 0.985,
        onTap: () => locator<NavigationService>().navigateToSearchView(),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: dark ? surfaceDark : surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: onSurface.withOpacity(dark ? 0.07 : 0.08)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  size: 20, color: onSurface.withOpacity(0.5)),
              const SizedBox(width: 10),
              Text(
                'Search 4K wallpapers, characters, colours',
                style: TextStyle(
                  fontSize: 14,
                  color: onSurface.withOpacity(0.42),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured hero
// ---------------------------------------------------------------------------

class FeaturedItem {
  final PopularWall wall;
  final String kicker;
  const FeaturedItem(this.wall, this.kicker);
}

class FeaturedCarousel extends StatefulWidget {
  final List<FeaturedItem> items;
  const FeaturedCarousel({super.key, required this.items});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _page =
      PageController(viewportFraction: kFeaturedFraction);
  Timer? _timer;
  double _pos = 0;

  @override
  void initState() {
    super.initState();
    _page.addListener(() {
      final p = _page.page ?? 0;
      if (p != _pos) setState(() => _pos = p);
    });
    _arm();
  }

  void _arm() {
    _timer?.cancel();
    if (widget.items.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_page.hasClients) return;
      final next = ((_page.page ?? 0).round() + 1) % widget.items.length;
      _page.animateToPage(next,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        SizedBox(
          height: kFeaturedH,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              if (n.direction != ScrollDirection.idle) {
                _timer?.cancel();
              } else {
                _arm();
              }
              return false;
            },
            child: PageView.builder(
              controller: _page,
              itemCount: items.length,
              itemBuilder: (context, i) {
                final delta = (i - _pos).clamp(-1.0, 1.0);
                return _FeaturedCard(item: items[i], delta: delta);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final active = (i - _pos).abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 6,
              height: 4,
              decoration: BoxDecoration(
                color: active ? onSurface : onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final FeaturedItem item;
  final double delta;
  const _FeaturedCard({required this.item, required this.delta});

  @override
  Widget build(BuildContext context) {
    final wall = item.wall;
    final scale = 1 - delta.abs() * 0.05;
    return Transform.scale(
      scale: scale,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Pressable(
          scale: 0.985,
          onTap: () => openWall(wall,
              onOpen: () => AnalyticsService.instance
                  .logWallOfDayClick(wall.id.toString())),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image drifts against the swipe for depth.
                Transform.translate(
                  offset: Offset(-delta * 36, 0),
                  child: Transform.scale(
                    scale: 1.16,
                    child: CacheImage(
                      wall: wall,
                      imageUrl: wall.thumbnailUrl,
                      memCacheHeight: 1300,
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xCC000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.kicker.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: Colors.white70,
                            ),
                          ),
                          if (wall.isPremium) ...[
                            const SizedBox(width: 10),
                            const PremiumBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wall.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 28,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.9,
                          color: Colors.white,
                        ),
                      ),
                      if (wall.designer.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'by ${wall.designer}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shelves
// ---------------------------------------------------------------------------

class WallShelf extends StatelessWidget {
  final List<PopularWall> walls;
  final String prefix;
  final int maxItems;
  final void Function(PopularWall wall)? onTap;

  const WallShelf({
    super.key,
    required this.walls,
    required this.prefix,
    this.maxItems = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = walls.length > maxItems ? walls.sublist(0, maxItems) : walls;
    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: kShelfCardH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final wall = items[i];
          return Reveal(
            axis: Axis.horizontal,
            offset: 30,
            delay: Duration(milliseconds: 55 * (i > 5 ? 5 : i)),
            child: SizedBox(
              width: kShelfCardW,
              child: BuffyImage(
                wall: wall,
                heroTag: '${prefix}_${i}_${wall.imageUrl}',
                onTap: onTap == null ? null : () => onTap!(wall),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String name;
  final int count;
  final PopularWall? cover;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.name,
    required this.count,
    required this.cover,
    required this.onTap,
    this.width = kCatTileW,
    this.height = kCatTileH,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: 0.97,
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (cover != null)
                CacheImage(wall: cover, imageUrl: cover!.thumbnailUrl)
              else
                ColoredBox(color: surfaceDark),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0, -0.1),
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xD9000000)],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count wallpapers',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryShelf extends StatelessWidget {
  final Map<String, List<PopularWall>> categories;
  final void Function(String name) onTap;
  const CategoryShelf({super.key, required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final names = categories.keys.toList();
    if (names.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: kCatTileH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final walls = categories[names[i]] ?? const <PopularWall>[];
          return Reveal(
            axis: Axis.horizontal,
            offset: 30,
            delay: Duration(milliseconds: 55 * (i > 5 ? 5 : i)),
            child: CategoryTile(
              name: names[i],
              count: walls.length,
              cover: walls.isEmpty ? null : walls.first,
              onTap: () => onTap(names[i]),
            ),
          );
        },
      ),
    );
  }
}

class CollectionShelf extends StatelessWidget {
  final List<String> names;
  final PopularWall? Function(String name) coverFor;
  final void Function(String name) onTap;
  const CollectionShelf({
    super.key,
    required this.names,
    required this.coverFor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: kCollectionH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final cover = coverFor(names[i]);
          return Pressable(
            scale: 0.97,
            onTap: () => onTap(names[i]),
            child: SizedBox(
              width: kCollectionW,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (cover != null)
                      CacheImage(wall: cover, imageUrl: cover.thumbnailUrl)
                    else
                      ColoredBox(color: surfaceDark),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xCC000000), Color(0x22000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Text(
                        names[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ColorSwatchRow extends StatelessWidget {
  final void Function(Color color) onTap;
  const ColorSwatchRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final names = HomeViewModel.namedColors;
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final color = names[i].toLowerCase().toColor();
          return Pressable(
            scale: 0.92,
            onTap: () => onTap(color),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: onSurface.withOpacity(0.18), width: 1.5),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  names[i],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Pill row used to filter the Explore grid.
class FilterPills extends StatelessWidget {
  final List<String> labels;
  final Set<String> selected;
  final void Function(String label) onTap;
  const FilterPills({
    super.key,
    required this.labels,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final label = labels[i];
          final on = selected.contains(label);
          final premium = label == AppStrings.premiumTitle;
          return Pressable(
            scale: 0.94,
            onTap: () => onTap(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on
                    ? (premium ? gold : onSurface)
                    : (dark ? surfaceDark : surfaceLight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: on
                      ? Colors.transparent
                      : (premium
                          ? gold.withOpacity(0.55)
                          : onSurface.withOpacity(0.1)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (premium) ...[
                    Icon(Icons.lock_rounded,
                        size: 13, color: on ? onGold : gold),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: on
                          ? (premium
                              ? onGold
                              : Theme.of(context).scaffoldBackgroundColor)
                          : onSurface.withOpacity(0.8),
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

// ---------------------------------------------------------------------------
// Skeletons — same dimensions as the widgets above.
// ---------------------------------------------------------------------------

class SkelTitle extends StatelessWidget {
  const SkelTitle({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SkelBox(width: 150, height: 24, radius: 8),
        ),
      );
}

class SkelShelf extends StatelessWidget {
  final double itemW;
  final double itemH;
  final double radius;
  const SkelShelf({
    super.key,
    this.itemW = kShelfCardW,
    this.itemH = kShelfCardH,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: itemH,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) =>
              SkelBox(width: itemW, height: itemH, radius: radius),
        ),
      );
}

class SkelGrid extends StatelessWidget {
  final int rows;
  const SkelGrid({super.key, this.rows = 3});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cell = (w - 40 - 24) / 3;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          rows,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: List.generate(
                3,
                (c) => Padding(
                  padding: EdgeInsets.only(left: c == 0 ? 0 : 12),
                  child: SkelBox(width: cell, height: cell / 0.6, radius: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail pages
// ---------------------------------------------------------------------------

/// Collapsing cover header shared by category and collection pages.
class SliverDetailHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final PopularWall? cover;
  const SliverDetailHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 330,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Pressable(
          scale: 0.9,
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0x73000000), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, c) {
          final top = MediaQuery.of(context).padding.top;
          final min = kToolbarHeight + top;
          const max = 330.0;
          // 1 when fully expanded, 0 when collapsed.
          final t = ((c.maxHeight - min) / (max - min)).clamp(0.0, 1.0);
          final onSurface = Theme.of(context).colorScheme.onSurface;
          final bg = Theme.of(context).scaffoldBackgroundColor;
          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: t,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (cover != null)
                      CacheImage(
                        wall: cover,
                        imageUrl: cover!.thumbnailUrl,
                        memCacheHeight: 1100,
                      )
                    else
                      const ColoredBox(color: surfaceDark),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.35, 1],
                          colors: [Colors.transparent, bg],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Opacity(
                  opacity: t,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 38,
                          height: 1.02,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.4,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 60,
                right: 20,
                top: top,
                height: kToolbarHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: ((1 - t) * 1.6 - 0.6).clamp(0.0, 1.0),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The BuffyWalls app icon (free or Pro artwork) as a rounded tile, used on
/// splash-style screens and dialogs.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.23),
      child: Image.asset(
        BuffyService.isPro ? Images.iconPro : Images.iconFree,
        width: size,
        height: size,
      ),
    );
  }
}
