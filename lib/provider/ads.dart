import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/ads_unit.dart';

class BannerAdmob extends StatefulWidget {
  const BannerAdmob({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BannerAdmobState();
  }
}

class _BannerAdmobState extends State<BannerAdmob> {
  late BannerAd _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdmobUnitID.getBannerID!,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _bannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          setState(() {
            _bannerReady = false;
          });
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerReady
        ? Center(
            child: SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AdWidget(ad: _bannerAd)),
            ),
          )
        : Container();
  }
}

// class InterstitialAdmob extends StatefulWidget {
//   const InterstitialAdmob({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _InterstitialAdmobState();
//   }
// }

// class _InterstitialAdmobState extends State<InterstitialAdmob> {
//   late InterstitialAd _bannerAd;
//   bool _bannerReady = false;

//   @override
//   void initState() {
//     super.initState();
//     InterstitialAd.load(
//       adUnitId: AdmobUnitID.getInterstitialID!,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           setState(() {
//             _bannerReady = true;
//             _bannerAd = ad;
//           });
//         },
//         onAdFailedToLoad: (err) {
//           setState(() {
//             _bannerReady = false;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _bannerAd.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if(_bannerReady)
//       _bannerAd.show();
//     return  Container();
//   }
// }

class InterstitialsAds {
  static InterstitialAd? _interstitialAd;

  static Future<void> createAd() async {
    debugPrint("yahooo");
    return await InterstitialAd.load(
      adUnitId: AdmobUnitID.getInterstitialID!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint("Ads Loaded");
        },
        onAdFailedToLoad: (err) {
          debugPrint("error$err");
        },
      ),
    );
  }

  static void showAd() {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
