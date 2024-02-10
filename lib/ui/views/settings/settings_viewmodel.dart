import 'package:buffywalls/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../view_export.dart';

class SettingsViewModel extends BaseViewModel {
  final _homeViewModel = locator<HomeViewModel>();

  String get getBannerImage => BuffyService.isPro
      ? _homeViewModel.data.banners.paid
      : _homeViewModel.data.banners.free;

  void onThemeTileTap() {
    // TODO
  }

  void onCacheTileTap() {
    // TODO
  }

  void onChangelogTileTap() {
    // TODO
  }

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
