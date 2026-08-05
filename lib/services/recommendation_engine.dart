import 'dart:math';

import '../models/model_export.dart';

/// Local, on-device wallpaper recommender shared by the Home "Recommended
/// For You" feed and the wallpaper detail "Infinite Discovery" carousel.
///
/// No AI, no backend — pure scoring over data already present on
/// [PopularWall]. Always backfills to [limit] (hot -> latest -> seeded
/// random) so callers never end up with an empty/dead-end result.
class RecommendationEngine {
  const RecommendationEngine._();

  static List<PopularWall> recommend({
    required List<PopularWall> pool,
    Set<int> excludeIds = const {},
    Set<String> categories = const {},
    Set<String> tags = const {},
    Set<int> colorValues = const {},
    bool? premiumLean,
    int limit = 12,
    int randomSeed = 0,
  }) {
    final candidates =
        pool.where((w) => !excludeIds.contains(w.id)).toList();
    if (candidates.isEmpty) return [];

    final lowerTags = tags.map((t) => t.toLowerCase()).toSet();
    final indexOf = <int, int>{
      for (var i = 0; i < candidates.length; i++) candidates[i].id: i,
    };

    double scoreOf(PopularWall w) {
      double score = 0.0;
      if (categories.contains(w.category)) score += 10.0;
      final tagMatches =
          w.tags.where((t) => lowerTags.contains(t.toLowerCase())).length;
      score += tagMatches * 2.0;
      final colorMatches =
          w.colors.where((c) => colorValues.contains(c.toARGB32())).length;
      score += colorMatches * 1.5;
      if (premiumLean != null && w.isPremium == premiumLean) score += 3.0;
      if (w.isHot) score += 2.0;
      return score;
    }

    final scored = candidates.map((w) => MapEntry(w, scoreOf(w))).toList()
      ..sort((a, b) {
        final byScore = b.value.compareTo(a.value);
        if (byScore != 0) return byScore;
        final byOrder = indexOf[a.key.id]!.compareTo(indexOf[b.key.id]!);
        if (byOrder != 0) return byOrder;
        return a.key.id.compareTo(b.key.id);
      });

    final result = <PopularWall>[];
    final seen = <int>{};
    void addAll(Iterable<PopularWall> list) {
      for (final w in list) {
        if (seen.add(w.id)) result.add(w);
        if (result.length >= limit) return;
      }
    }

    addAll(scored.where((e) => e.value > 0).map((e) => e.key));
    if (result.length < limit) {
      addAll(candidates.where((w) => w.isHot));
    }
    if (result.length < limit) {
      addAll(candidates); // list order acts as "latest"
    }
    if (result.length < limit) {
      final remainder = candidates.where((w) => !seen.contains(w.id)).toList()
        ..shuffle(Random(randomSeed));
      addAll(remainder);
    }

    return result.take(limit).toList();
  }
}
