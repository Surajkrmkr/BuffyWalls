import '../../../app/app.locator.dart';
import '../../../app/app.package.export.dart';

class CacheDialogModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void clearCache() {
    DefaultCacheManager().emptyCache();
    onCancle();
  }

  void onCancle() => _navigationService.back();
}
