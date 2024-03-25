import '../app/app.package.export.dart';

class AdsService {
  final String rewardedId = "ca-app-pub-4861691653340010/4965253463";
  RewardedAd? rewardedAd;

  bool isRewardedAdLoading = false;

  // set setIsRewardedAdLoading(val) {
  //   isRewardedAdLoading = val;
  //   notifyListeners();
  // }

  // void loadRewardedAd(BuildContext context, {required Function() onRewarded}) {
  //   setIsRewardedAdLoading = true;
  //   RewardedAd.load(
  //       adUnitId: rewardedId,
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (ad) {
  //           rewardedAd = ad;
  //           ad.fullScreenContentCallback = FullScreenContentCallback(
  //             onAdDismissedFullScreenContent: (ad) {
  //               Navigator.pop(context);
  //               onRewarded();
  //             },
  //           );
  //           ad.show(onUserEarnedReward: (ad, reward) {
  //             logger.i(reward.amount);
  //             setIsRewardedAdLoading = false;
  //           });
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           logger.e('RewardedAd failed to load: $error');
  //           setIsRewardedAdLoading = false;
  //         },
  //       ));
  // }
}
