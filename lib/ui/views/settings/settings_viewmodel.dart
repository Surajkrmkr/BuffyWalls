import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/common_export.dart';

class SettingsViewModel extends BaseViewModel {
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
    Share.share(AppStrings.checkOutBuffy + Links.buffyFree);
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
