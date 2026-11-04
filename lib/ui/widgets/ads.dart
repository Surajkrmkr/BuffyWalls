import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import 'motion.dart';

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
        ? const SizedBox.shrink()
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

/// A native ad styled to sit in the feed like any other card. It reserves
/// its final height up front (a shimmer block while loading) so nothing
/// below it moves when the ad arrives, and collapses if no ad fills.
class NativeFeedAd extends StatefulWidget {
  final bool compact;
  final bool forceDark;
  const NativeFeedAd({super.key, this.compact = false, this.forceDark = false});

  double get height => compact ? 112 : 372;

  @override
  State<NativeFeedAd> createState() => _NativeFeedAdState();
}

class _NativeFeedAdState extends State<NativeFeedAd> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _failed = false;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested || BuffyService.isPro) return;
    _requested = true;
    final dark =
        widget.forceDark || Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? surfaceDark : surfaceLight;
    final text = dark ? Colors.white : Colors.black;
    _ad = NativeAd(
      adUnitId: AdMob.nativeAdUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType:
            widget.compact ? TemplateType.small : TemplateType.medium,
        mainBackgroundColor: surface,
        cornerRadius: 18,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: onGold,
          backgroundColor: gold,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: text,
          style: NativeTemplateFontStyle.bold,
          size: 15,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: text.withOpacity(0.6),
          size: 13,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: text.withOpacity(0.45),
          size: 12,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _ad = null;
          if (mounted) setState(() => _failed = true);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (BuffyService.isPro || _failed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SizedBox(
        height: widget.height,
        child: _loaded && _ad != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AdWidget(ad: _ad!),
              )
            : ShimmerHost(child: SkelBox(radius: 18, height: widget.height)),
      ),
    );
  }
}
