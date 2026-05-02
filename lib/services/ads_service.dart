import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../ui/common/common_export.dart';

class AdsService extends BaseViewModel {
  final logger = getLogger('AdsService');
  final _navigator = locator<NavigationService>();

  RewardedAd? rewardedAd;
  InterstitialAd? interstitialAd;

  void loadInterstitialAd() {
    setBusy(true);
    InterstitialAd.load(
        adUnitId: AdMob.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            setBusy(false);
            interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
              interstitialAd!.dispose();
              loadInterstitialAd();
            }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, adError) {
              interstitialAd!.dispose();
              loadInterstitialAd();
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.e('InterstitialAd failed to load: $error');
            interstitialAd!.dispose();
            setBusy(false);
          },
        ));
  }

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
