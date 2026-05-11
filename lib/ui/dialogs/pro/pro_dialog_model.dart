import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';

class ProDialogModel extends BaseViewModel {
  final _adService = locator<AdsService>();

  void onGetProTapped() => launchUrl(Uri.parse(Links.buffyPaid),
      mode: LaunchMode.externalNonBrowserApplication);

  void onWatchAdTapped(VoidCallback onSuccess) {
    _adService.loadRewardedAd(
      onRewarded: onSuccess,
      navigateBack: false,
    );
  }
}
