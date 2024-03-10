import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../view_export.dart';

class SettingsViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();
  final _dialogService = locator<DialogService>();

  String get getBannerImage => BuffyService.isPro
      ? _homeViewModel.data.banners.paid
      : _homeViewModel.data.banners.free;

  void onBannerTapped() =>
      onSocialTileTap(BuffyService.isPro ? Links.devPage : Links.buffyPaid);

  void onThemeTileTap() => _dialogService.showCustomDialog(
        variant: DialogType.theme,
        barrierDismissible: true,
      );

  void onCacheTileTap() => _dialogService.showCustomDialog(
        variant: DialogType.cache,
        barrierDismissible: true,
      );

  void onChangelogTileTap() => _dialogService.showCustomDialog(
        variant: DialogType.changelog,
        barrierDismissible: true,
      );

  void onShareTileTap() {
    Share.share(AppStrings.checkOutBuffy +
        (BuffyService.isPro ? Links.buffyPaid : Links.buffyFree));
  }

  void onDonateTileTap() {
    // TODO
  }

  void onAboutUsTileTap() {
    // TODO
  }

  void onSocialTileTap(String social, {bool isEmail = false}) {
    launchUrl(Uri.parse(isEmail ? 'mailto:$social' : social),
        mode: LaunchMode.externalNonBrowserApplication);
  }
}
