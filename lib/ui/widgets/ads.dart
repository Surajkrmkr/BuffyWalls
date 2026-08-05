import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';

class AdsWidget extends StatefulWidget {
  final double bottomPadding;
  final AdSize size;
  final String? adUnitId;
  const AdsWidget(
      {super.key,
      this.bottomPadding = 10,
      this.size = AdSize.banner,
      this.adUnitId});

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
      adUnitId: widget.adUnitId ?? AdMob.bannerAdUnitId,
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
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
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

class GridCellAdWidget extends StatefulWidget {
  const GridCellAdWidget({super.key});

  @override
  State<GridCellAdWidget> createState() => _GridCellAdWidgetState();
}

class _GridCellAdWidgetState extends State<GridCellAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!BuffyService.isPro) {
      _loadAd();
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdMob.nativeAdUnitId,
      factoryId: null,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.transparent,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
        },
      ),
    );
    _nativeAd!.load().catchError((_) {
      _nativeAd?.dispose();
      _nativeAd = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (BuffyService.isPro || !_isLoaded || _nativeAd == null) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.ads_click_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            size: 24,
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: Theme.of(context).cardColor,
        alignment: Alignment.center,
        child: SizedBox(
          height: 90,
          child: AdWidget(ad: _nativeAd!),
        ),
      ),
    );
  }
}
