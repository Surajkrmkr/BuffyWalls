import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../services/service_export.dart';

class AdsWidget extends StatefulWidget {
  final double bottomPadding;
  final AdSize size;
  const AdsWidget(
      {super.key, this.bottomPadding = 10, this.size = AdSize.banner});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();

  static Widget getPlusDialog(BuildContext context,
      {void Function()? onWatchAdClick, bool isExplorePlus = false}) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
              child: Text(
            isExplorePlus ? "Explore Plus" : "Unlock Wallpaper",
          )),
          const CloseButton()
        ],
      ),
      content: Text(
        isExplorePlus
            ? "Upgrade to Plus to unlock exclusive features and take your experience to the next level!"
            : "Get access to the wallpapers by either watching an ad or purchasing the Plus Subscription.",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        // Offstage(
        //   offstage: isExplorePlus,
        //   child: Consumer<AdsProvider>(builder: (context, provider, _) {
        //     return provider.isRewardedAdLoading
        //         ? ShimmerWidget.withWidget(
        //             _getWatchAdBtnUI(onWatchAdClick ?? () {}), context)
        //         : _getWatchAdBtnUI(onWatchAdClick ?? () {});
        //   }),
        // ),
        Visibility(
          visible: isExplorePlus,
          replacement: OutlinedButton.icon(
              icon: const Icon(Icons.verified),
              onPressed: () => _onPlusClick(context),
              label: const Text("Go Plus")),
          child: FilledButton.icon(
              onPressed: () => _onPlusClick(context),
              icon: const Icon(Icons.verified),
              label: const Text("Go Plus")),
        )
      ],
    );
  }

  static FilledButton _getWatchAdBtnUI(void Function() onWatchAdClick) {
    return FilledButton(
        onPressed: onWatchAdClick, child: const Text("Watch AD"));
  }

  static void _onPlusClick(context) {
    Navigator.pop(context);
    // TODO
  }
}

class _AdsWidgetState extends State<AdsWidget> {
  final String _bannerId = "ca-app-pub-4861691653340010/8536832813";
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
      adUnitId: _bannerId,
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
