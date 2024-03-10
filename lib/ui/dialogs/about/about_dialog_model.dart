import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../views/view_export.dart';

class AboutDialogModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  final _navigationService = locator<NavigationService>();

  String get currentVersion => "v${_homeViewModel.currentVersion}";

  void onRateUsTapped() => launchUrl(
      Uri.parse(BuffyService.isPro ? Links.buffyPaid : Links.buffyFree),
      mode: LaunchMode.externalNonBrowserApplication);

  void onGotItTapped() => _navigationService.back();
}
