import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _adsService = locator<AdsService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    AnalyticsService.instance.logScreenView('startup');
    await Future.wait([
      _adsService.initializeAds(),
      Future.delayed(const Duration(milliseconds: 500)),
    ]);
    BuffyService.isInitialized
        ? _navigationService.replaceWithNavigationView()
        : _navigationService.replaceWithOnboardView();
  }
}
