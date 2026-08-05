import 'dart:math';

/// Pure planner for where native ads land inside a wallpaper grid.
/// Deliberately Flutter-free so it's trivially testable.
///
/// Deterministic per [seed] (stable across rebuilds when seeded by
/// something that doesn't change every frame, e.g. the wallpaper count
/// itself, or a day-of-year value), but the *gaps* between ad slots are
/// randomized within [minGap]..[maxGap] rather than a fixed interval.
class AdSlotPlanner {
  const AdSlotPlanner._();

  /// Returns the 0-based indices (into a flat list of [totalCount] items)
  /// that should render as an ad cell instead of a wallpaper.
  ///
  /// Guarantees, by construction (no post-hoc filtering needed):
  /// - never index 0 or `totalCount - 1` (never first/last)
  /// - consecutive ad slots are always >= [minGap] apart (never adjacent,
  ///   always "enough wallpaper content between monetization opportunities")
  static Set<int> plan(
    int totalCount, {
    int minGap = 10,
    int maxGap = 12,
    int seed = 0,
  }) {
    if (totalCount <= minGap + 1) return {};

    final random = Random(seed);
    final slots = <int>{};
    int next = minGap + random.nextInt(maxGap - minGap + 1);

    while (next < totalCount - 1) {
      slots.add(next);
      next += minGap + random.nextInt(maxGap - minGap + 1);
    }

    return slots;
  }
}
