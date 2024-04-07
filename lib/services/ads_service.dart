import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../ui/common/common_export.dart';

class AdsService extends BaseViewModel {
  final logger = getLogger('AdsService');
  final _navigator = locator<NavigationService>();

  RewardedAd? rewardedAd;

  void loadRewardedAd({required Function() onRewarded}) {
    setBusy(true);
    RewardedAd.load(
        adUnitId: AdMob.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _navigator.back();
                onRewarded();
              },
            );
            ad.show(onUserEarnedReward: (ad, reward) {
              logger.i(reward.amount);
              setBusy(false);
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.e('RewardedAd failed to load: $error');
            setBusy(false);
          },
        ));
  }
}
