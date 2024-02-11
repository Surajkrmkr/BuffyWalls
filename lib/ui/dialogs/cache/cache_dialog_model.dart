import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class CacheDialogModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void clearCache() {
    DefaultCacheManager().emptyCache();
    onCancle();
  }

  void onCancle() => _navigationService.back();
}
