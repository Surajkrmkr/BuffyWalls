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

  void logSettingsScreen() => AnalyticsService.instance.logSettingsScreen();

  void onThemeTileTap() {
    AnalyticsService.instance.logSettingsTapped('theme');
    _dialogService.showCustomDialog(
      variant: DialogType.theme,
      barrierDismissible: true,
    );
  }

  void onCacheTileTap() {
    AnalyticsService.instance.logSettingsTapped('cache');
    _dialogService.showCustomDialog(
      variant: DialogType.cache,
      barrierDismissible: true,
    );
  }

  void onChangelogTileTap() {
    AnalyticsService.instance.logSettingsTapped('changelog');
    _dialogService.showCustomDialog(
      variant: DialogType.changelog,
      barrierDismissible: true,
    );
  }

  void onShareTileTap() {
    AnalyticsService.instance.logSettingsTapped('share');
    SharePlus.instance.share(ShareParams(
        text: AppStrings.checkOutBuffy +
            (BuffyService.isPro ? Links.buffyPaid : Links.buffyFree)));
  }

  void onDonateTileTap() {
    AnalyticsService.instance.logSettingsTapped('donate');
  }

  void onAboutUsTileTap() {
    AnalyticsService.instance.logSettingsTapped('about');
    _dialogService.showCustomDialog(
      variant: DialogType.about,
      barrierDismissible: true,
    );
  }

  void onSocialTileTap(String social, {bool isEmail = false}) {
    AnalyticsService.instance.logSettingsTapped(social);
    launchUrl(Uri.parse(isEmail ? 'mailto:$social' : social),
        mode: LaunchMode.externalNonBrowserApplication);
  }
}
