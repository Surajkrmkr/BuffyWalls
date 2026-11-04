import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../ui/common/common_export.dart';
import '../ui/widgets/toast.dart';
import 'buffy_service.dart';
import 'shared_pref_service.dart';

class AdsService extends BaseViewModel {
  final logger = getLogger('AdsService');
  final _navigator = locator<NavigationService>();
  final _sharedPrefService = locator<SharedPrefService>();

  RewardedAd? rewardedAd;
  InterstitialAd? interstitialAd;
  bool _adsInitialized = false;

  Future<void> initializeAds() async {
    if (_adsInitialized) return;
    await _requestConsent();
    // Debug-only: serve test ads on a developer device so tapping through
    // the UI never clicks a live ad. Pass --dart-define=ADMOB_TEST_DEVICE_ID=<id>.
    const testDeviceId = String.fromEnvironment('ADMOB_TEST_DEVICE_ID');
    if (kDebugMode && testDeviceId.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: [testDeviceId]));
    }
    await MobileAds.instance.initialize();
    _adsInitialized = true;
  }

  Future<void> _requestConsent() async {
    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          await ConsentForm.loadAndShowConsentFormIfRequired(
            (FormError? formError) {
              if (formError != null) {
                logger.e('Consent form error: ${formError.message}');
              }
            },
          );
        } finally {
          completer.complete();
        }
      },
      (FormError formError) {
        logger.e('Consent info update failed: ${formError.message}');
        completer.complete();
      },
    );

    return completer.future;
  }
  BannerAd? _dialogBannerAd;
  bool _interstitialLoading = false;
  bool _dialogAdLoading = false;

  Future<void> loadInterstitialAd() async {
    if (BuffyService.isPro) return;
    if (interstitialAd != null || _interstitialLoading) return;
    _interstitialLoading = true;
    try {
      await InterstitialAd.load(
          adUnitId: AdMob.interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              interstitialAd = ad;
              _interstitialLoading = false;
              interstitialAd!.fullScreenContentCallback =
                  FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (InterstitialAd ad) {
                interstitialAd = null;
                ad.dispose();
              }, onAdFailedToShowFullScreenContent:
                      (InterstitialAd ad, adError) {
                interstitialAd = null;
                ad.dispose();
              });
            },
            onAdFailedToLoad: (LoadAdError error) {
              logger.e('InterstitialAd failed to load: $error');
              _interstitialLoading = false;
            },
          ));
    } catch (e) {
      logger.e('InterstitialAd load exception: $e');
      _interstitialLoading = false;
    }
  }

  Future<void> loadDialogAd() async {
    // Pop-up dialog ad disabled as requested
    return;
  }

  void _showDialogAd() {
    if (_dialogBannerAd == null || !_sharedPrefService.canShowDialogAd()) {
      _dialogBannerAd?.dispose();
      _dialogBannerAd = null;
      return;
    }
    // ignore: deprecated_member_use
    final context = _navigator.navigatorKey?.currentContext;
    if (context == null) {
      _dialogBannerAd?.dispose();
      _dialogBannerAd = null;
      return;
    }
    _sharedPrefService.recordDialogAdShown();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        clipBehavior: Clip.hardEdge,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            SizedBox(
              width: AdSize.mediumRectangle.width.toDouble(),
              height: AdSize.mediumRectangle.height.toDouble(),
              child: AdWidget(ad: _dialogBannerAd!),
            ),
          ],
        ),
      ),
    ).then((_) {
      _dialogBannerAd?.dispose();
      _dialogBannerAd = null;
    });
  }

  void showInterstitialAd() {
    if (BuffyService.isPro) return;
    if (interstitialAd != null) {
      interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  bool _rewardedLoading = false;

  /// Loads and immediately shows a rewarded video. [onRewarded] only fires
  /// if the user actually watched through to [onUserEarnedReward] — closing
  /// the ad early doesn't grant the reward. Repeat taps while an ad is
  /// loading are ignored, and the busy state is always reset when the ad
  /// is dismissed, fails to show, or fails to load.
  void loadRewardedAd(
      {required Function() onRewarded, bool navigateBack = true}) {
    if (_rewardedLoading) return;
    _rewardedLoading = true;
    setBusy(true);
    bool earned = false;

    void finish(RewardedAd? ad) {
      _rewardedLoading = false;
      rewardedAd = null;
      ad?.dispose();
      setBusy(false);
    }

    RewardedAd.load(
        adUnitId: AdMob.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                finish(ad);
                if (navigateBack) _navigator.back();
                if (earned) onRewarded();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                logger.e('RewardedAd failed to show: $error');
                finish(ad);
                showToast('Ad could not be shown. Please try again.');
              },
            );
            ad.show(onUserEarnedReward: (ad, reward) {
              logger.i(reward.amount);
              earned = true;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.e('RewardedAd failed to load: $error');
            finish(null);
            showToast('No ad available right now. Please try again later.');
          },
        ));
  }
}
