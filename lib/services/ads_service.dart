import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app.export.dart';
import '../app/app.package.export.dart';
import '../ui/common/common_export.dart';
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
    if (BuffyService.isPro) return;
    if (_dialogBannerAd != null || _dialogAdLoading) return;
    if (!_sharedPrefService.canShowDialogAd()) return;
    _dialogAdLoading = true;
    _dialogBannerAd = BannerAd(
      adUnitId: AdMob.dialogBannerAdUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _dialogAdLoading = false;
          _showDialogAd();
        },
        onAdFailedToLoad: (ad, error) {
          logger.e('Dialog ad failed to load: $error');
          _dialogAdLoading = false;
          ad.dispose();
          _dialogBannerAd = null;
        },
      ),
    );
    try {
      await _dialogBannerAd!.load();
    } catch (e) {
      logger.e('Dialog ad load exception: $e');
      _dialogAdLoading = false;
      _dialogBannerAd?.dispose();
      _dialogBannerAd = null;
    }
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
    if (interstitialAd != null) {
      interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  void loadRewardedAd(
      {required Function() onRewarded, bool navigateBack = true}) {
    setBusy(true);
    RewardedAd.load(
        adUnitId: AdMob.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                if (navigateBack) _navigator.back();
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
