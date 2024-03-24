import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(milliseconds: 500));
    BuffyService.isInitialized
        ? _navigationService.replaceWithNavigationView()
        : _navigationService.replaceWithOnboardView();
  }
}
