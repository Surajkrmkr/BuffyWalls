import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';

class AdsWidget extends StatefulWidget {
  final double bottomPadding;
  final AdSize size;
  const AdsWidget(
      {super.key, this.bottomPadding = 10, this.size = AdSize.banner});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  bool _isBannerLoading = false;
  bool _isBannerFailed = false;
  BannerAd? bannerAd;

  @override
  void initState() {
    if (!BuffyService.isPro) loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    if (!BuffyService.isPro) bannerAd!.dispose();
    super.dispose();
  }

  set setBannerLoading(bool val) => setState(() => _isBannerLoading = val);

  void loadBannerAd() {
    setBannerLoading = true;
    bannerAd = BannerAd(
      adUnitId: AdMob.bannerAdUnitId,
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setBannerLoading = false;
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerFailed = true;
          setBannerLoading = false;
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerLoading || BuffyService.isPro || _isBannerFailed
        ? Container()
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: widget.bottomPadding),
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: bannerAd!),
            ),
          );
  }
}
