import '../app/app.package.export.dart';

/// The one cache for every network image in the app.
///
/// It reuses the default cache's name so files already on disk stay usable
/// and the clear-cache dialog empties them too. Don't use
/// [DefaultCacheManager] alongside it, because both would open the same files.
class BuffyCacheManager {
  BuffyCacheManager._();

  static final CacheManager instance = CacheManager(
    Config(DefaultCacheManager.key, maxNrOfCacheObjects: 1000),
  );

  static String fullKey(String url, int? wallId) =>
      (wallId != null && wallId != 0)
          ? 'full_${wallId}_${url.hashCode}'
          : 'full_$url';

  static String thumbKey(String url, int? wallId) =>
      (wallId != null && wallId != 0)
          ? 'thumb_${wallId}_${url.hashCode}'
          : 'thumb_$url';
}
