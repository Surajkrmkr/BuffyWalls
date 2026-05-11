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
    bannerAd?.dispose();
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
    );
    bannerAd!.load().catchError((_) {
      _isBannerFailed = true;
      setBannerLoading = false;
      bannerAd?.dispose();
      bannerAd = null;
    });
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

class GridAdWidget extends StatefulWidget {
  const GridAdWidget({super.key});

  @override
  State<GridAdWidget> createState() => _GridAdWidgetState();
}

class _GridAdWidgetState extends State<GridAdWidget> {
  BannerAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!BuffyService.isPro) _loadAd();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  void _loadAd() {
    _ad = BannerAd(
      adUnitId: AdMob.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (_) { if (mounted) setState(() => _isLoaded = true); },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    _ad!.load().catchError((_) {
      _ad?.dispose();
      _ad = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (BuffyService.isPro || !_isLoaded || _ad == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: _ad!.size.height.toDouble(),
      child: Center(
        child: SizedBox(
          width: _ad!.size.width.toDouble(),
          height: _ad!.size.height.toDouble(),
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
