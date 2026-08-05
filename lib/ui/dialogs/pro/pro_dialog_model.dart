import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';

class ProDialogModel extends BaseViewModel {
  final _adService = locator<AdsService>();

  void onGetProTapped() => launchUrl(Uri.parse(Links.buffyPaid),
      mode: LaunchMode.externalNonBrowserApplication);

  /// [wallId] is the specific premium wallpaper this dialog is gating, if
  /// any (passed via `DialogRequest.data['wallId']`). Watching the ad
  /// instantly and permanently (for today) unlocks that wallpaper — no
  /// coins, no redemption step.
  void onWatchAdTapped(VoidCallback onSuccess, {int? wallId}) {
    _adService.loadRewardedAd(
      navigateBack: false,
      onRewarded: () {
        MonetizationService.recordVideoWatched();
        if (wallId != null) MonetizationService.unlockToday(wallId);
        onSuccess();
      },
    );
  }
}
