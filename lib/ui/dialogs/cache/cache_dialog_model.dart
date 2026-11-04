import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';
import '../../../services/buffy_cache_manager.dart';

class CacheDialogModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void clearCache() {
    BuffyCacheManager.instance.emptyCache();
    onCancle();
  }

  void onCancle() => _navigationService.back();
}
