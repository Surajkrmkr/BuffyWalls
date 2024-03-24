import 'package:buffywalls/app/app.package.export.dart';
import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.export.dart';
import '../../../services/service_export.dart';

class OnboardViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _sharedPrefService = locator<SharedPrefService>();

  List<String> onBoardBanners = [];
  List<List<String>> onBoardCollections = [];

  Future<void> getBanners() async {
    setBusy(true);
    onBoardBanners = await _apiService.getOnboardBanners();
    if (onBoardBanners.isNotEmpty) {
      onBoardCollections = onBoardBanners.slices(5).toList();
    }
    setBusy(false);
  }

  void onEnterTapped() {
    _sharedPrefService.setInitialised();
    _navigationService.replaceWithNavigationView();
  }
}
