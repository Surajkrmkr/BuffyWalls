import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/model_export.dart';
import '../../services/service_export.dart';
import 'cache_image.dart';
import 'monetization_widgets.dart';

/// Horizontal, snap-scrolling row of [BuffyImage] cards. Used by every
/// carousel-shaped discovery section (Trending, Latest, Recommended,
/// Continue Browsing, Featured-in-collection, ...) so the card layout only
/// lives in one place.
class WallpaperCarousel extends StatelessWidget {
  final List<PopularWall> walls;
  final double height;
  final double cardWidth;
  final int maxItems;
  final void Function(PopularWall wall)? onWallTap;

  const WallpaperCarousel({
    super.key,
    required this.walls,
    this.height = 220,
    this.cardWidth = 130,
    this.maxItems = 10,
    this.onWallTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = walls.length > maxItems ? walls.sublist(0, maxItems) : walls;
    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final wall = items[index];
          return SizedBox(
            width: cardWidth,
            // BuffyImage already navigates to ImageView internally (and
            // handles the premium gate) — onWallTap hooks into that same
            // tap instead of adding a second, double-navigating handler.
            child: BuffyImage(
              wall: wall,
              onTap: onWallTap == null ? null : () => onWallTap!(wall),
            ),
          );
        },
      ),
    );
  }
}

/// Ad-interleaved 3-column wallpaper grid with a premium empty state.
/// Factored out of the near-identical grid-building code that used to be
/// duplicated across Home / Category / Common views.
///
/// This sits inside a plain `Column` (via `SliverToBoxAdapter`), not a lazy
/// `ListView`/`SliverList`, so it must never eagerly build every row for a
/// large [walls] list — each cell is a [BuffyImage] running its own Ken
/// Burns `AnimationController`, and building hundreds of them at once is
/// enough main-thread work to trigger an ANR. It self-paginates in pages of
/// [pageSize] instead, revealed via a "Load More" tap, so the initial build
/// cost stays bounded no matter how large the underlying list is.
class WallpaperGridSection extends StatefulWidget {
  final List<PopularWall> walls;
  final bool showAds;
  final int pageSize;
  final String emptyTitle;
  final String emptySubtitle;

  const WallpaperGridSection({
    super.key,
    required this.walls,
    this.showAds = true,
    this.pageSize = 60,
    this.emptyTitle = "No Wallpapers Found",
    this.emptySubtitle = "Try exploring another category or collection",
  });

  @override
  State<WallpaperGridSection> createState() => _WallpaperGridSectionState();
}

class _WallpaperGridSectionState extends State<WallpaperGridSection> {
  late int _visibleCount = widget.pageSize;

  @override
  Widget build(BuildContext context) {
    final walls = widget.walls;
    if (walls.isEmpty) {
      return _emptyState(context);
    }

    final hasMore = walls.length > _visibleCount;
    final visible = hasMore ? walls.sublist(0, _visibleCount) : walls;

    // Ad slots are planned against the FULL list (not just the visible
    // page) so density stays stable as more pages are revealed via "Load
    // More" instead of reshuffling already-seen ad positions. The set
    // holds "insert one ad after this many wallpapers" counts — additive,
    // never replacing a wallpaper — matching the spec's own framing
    // ("12 wallpapers -> ad -> 10 wallpapers -> ad -> ...").
    final adAfter = (!BuffyService.isPro && widget.showAds)
        ? AdSlotPlanner.plan(walls.length, seed: walls.length)
        : const <int>{};

    final cells = <Widget>[];
    int wallpapersPlaced = 0;
    for (final wall in visible) {
      cells.add(AspectRatio(aspectRatio: 0.6, child: BuffyImage(wall: wall)));
      wallpapersPlaced++;
      if (adAfter.contains(wallpapersPlaced)) {
        cells.add(const AspectRatio(aspectRatio: 0.6, child: NativeAdCard()));
      }
    }

    final List<Widget> rows = [];
    for (int i = 0; i < cells.length; i += 3) {
      if (i > 0) rows.add(const SizedBox(height: 12));
      rows.add(_row(cells, i));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Column(children: rows),
          if (hasMore) ...[
            const SizedBox(height: 16),
            _loadMoreButton(context, walls.length - _visibleCount),
          ],
        ],
      ),
    );
  }

  Widget _loadMoreButton(BuildContext context, int remaining) {
    return GestureDetector(
      onTap: () => setState(() => _visibleCount += widget.pageSize),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            "Load More ($remaining left)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> cells, int start) {
    final left = cells[start];
    final mid = start + 1 < cells.length ? cells[start + 1] : null;
    final right = start + 2 < cells.length ? cells[start + 2] : null;
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: mid ?? const SizedBox()),
        const SizedBox(width: 12),
        Expanded(child: right ?? const SizedBox()),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: onSurface.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bubble_chart_outlined,
                size: 48,
                color: onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.emptyTitle,
              style: TextStyle(
                color: onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.emptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fires [onImpression] once, the first time its child becomes >=50%
/// visible. Wrap any Home section in this to attach "section impression"
/// analytics without touching the section's own build logic.
class SectionImpressionTracker extends StatefulWidget {
  final String sectionKey;
  final Widget child;
  final void Function(String sectionKey) onImpression;

  const SectionImpressionTracker({
    super.key,
    required this.sectionKey,
    required this.child,
    required this.onImpression,
  });

  @override
  State<SectionImpressionTracker> createState() => _SectionImpressionTrackerState();
}

class _SectionImpressionTrackerState extends State<SectionImpressionTracker> {
  bool _fired = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('section_impression_${widget.sectionKey}'),
      onVisibilityChanged: (info) {
        if (_fired || !mounted) return;
        if (info.visibleFraction >= 0.5) {
          _fired = true;
          widget.onImpression(widget.sectionKey);
        }
      },
      child: widget.child,
    );
  }
}

/// Horizontal row of pill chips for "Related Categories" / "Related
/// Collections" / "Similar Colors" style cross-links at the bottom of a
/// detail page. [onTap] is expected to push-replace into a sibling detail
/// page so users can keep hopping between related content.
class RelatedChipsRow extends StatelessWidget {
  final List<String> labels;
  final void Function(String label) onTap;
  final Color? Function(String label)? colorFor;

  const RelatedChipsRow({
    super.key,
    required this.labels,
    required this.onTap,
    this.colorFor,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = labels[index];
          final swatch = colorFor?.call(label);
          return GestureDetector(
            onTap: () => onTap(label),
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
                  if (swatch != null) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: swatch, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
