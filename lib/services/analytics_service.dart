import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final _analytics = FirebaseAnalytics.instance;
  FirebaseAnalytics get observer => _analytics;

  // Screen views
  void logScreenView(String screenName) {
    _analytics.logScreenView(screenName: screenName);
  }

  void logHomeScreen() => logScreenView('home');
  void logSearchScreen() => logScreenView('search');
  void logCategoryScreen() => logScreenView('category');
  void logFavouriteScreen() => logScreenView('favourite');
  void logSettingsScreen() => logScreenView('settings');
  void logOnboardScreen() => logScreenView('onboard');
  void logImageScreen(String wallName) => logScreenView('image_$wallName');
  void logCollectionScreen(String title) =>
      logScreenView('collection_$title');

  // Home
  void logFilterSelected(String filter) {
    _analytics.logEvent(
        name: 'filter_selected', parameters: {'filter': filter});
  }

  void logBannerTapped(String bannerId, String category) {
    _analytics.logEvent(name: 'banner_tapped', parameters: {
      'banner_id': bannerId,
      'category': category,
    });
  }

  void logCollectionOpened(String collection) {
    _analytics.logEvent(
        name: 'collection_opened', parameters: {'collection': collection});
  }

  // Search
  void logSearch(String query) {
    _analytics.logSearch(searchTerm: query);
  }

  void logPopularWordSelected(String word) {
    _analytics.logEvent(
        name: 'popular_word_selected', parameters: {'word': word});
  }

  void logColorFilterSelected(String colorHex) {
    _analytics.logEvent(
        name: 'color_filter_selected', parameters: {'color': colorHex});
  }

  // Image
  void logWallpaperDownloaded(String wallName) {
    _analytics.logEvent(
        name: 'wallpaper_downloaded', parameters: {'wall_name': wallName});
  }

  void logWallpaperApplied(String wallName, String action) {
    _analytics.logEvent(name: 'wallpaper_applied', parameters: {
      'wall_name': wallName,
      'action': action,
    });
  }

  // Favourite
  void logAddToFavourites(String wallName) {
    _analytics.logEvent(
        name: 'add_to_favourites', parameters: {'wall_name': wallName});
  }

  void logRemoveFromFavourites(String wallName) {
    _analytics.logEvent(
        name: 'remove_from_favourites', parameters: {'wall_name': wallName});
  }

  // Category
  void logCategoryTabChanged(int index, String categoryName) {
    _analytics.logEvent(name: 'category_tab_changed', parameters: {
      'index': index,
      'category': categoryName,
    });
  }

  void logCategoryMoreOpened(String category) {
    _analytics.logEvent(
        name: 'category_more_opened', parameters: {'category': category});
  }

  // Navigation
  void logTabChanged(int index, String tabName) {
    _analytics.logEvent(name: 'tab_changed', parameters: {
      'tab_index': index,
      'tab_name': tabName,
    });
  }

  // Settings
  void logSettingsTapped(String setting) {
    _analytics.logEvent(
        name: 'settings_tapped', parameters: {'setting': setting});
  }

  // Onboard
  void logOnboardCompleted() {
    _analytics.logEvent(name: 'onboard_completed');
  }
}
