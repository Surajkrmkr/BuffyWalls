import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';

class CarouselBannerWidget extends StatefulWidget {
  final List<AdBanner> banners;
  final void Function(AdBanner) onTap;

  const CarouselBannerWidget({
    super.key,
    required this.banners,
    required this.onTap,
  });

  @override
  State<CarouselBannerWidget> createState() => _CarouselBannerWidgetState();
}

class _CarouselBannerWidgetState extends State<CarouselBannerWidget> {
  late final PageController _controller;
  late final List<_CarouselItem> _items;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _items = _buildItems();
    _controller = PageController();
    _startAutoScroll();
  }

  List<_CarouselItem> _buildItems() {
    final items = <_CarouselItem>[];
    for (int i = 0; i < widget.banners.length; i++) {
      if (i == 1 && !BuffyService.isPro) items.add(const _CarouselItem.ad());
      items.add(_CarouselItem.banner(widget.banners[i]));
    }
    return items;
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _items.length;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 90,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = _items[index];
              if (item.isAd) {
                return _AdSlide();
              }
              return _BannerSlide(
                banner: item.banner!,
                onTap: widget.onTap,
              );
            },
          ),
        ),
        verticalSpaceSmall,
        _DotsIndicator(count: _items.length, current: _currentPage),
      ],
    );
  }
}

class _CarouselItem {
  final AdBanner? banner;
  final bool isAd;
  const _CarouselItem.banner(this.banner) : isAd = false;
  const _CarouselItem.ad()
      : banner = null,
        isAd = true;
}

class _BannerSlide extends StatelessWidget {
  final AdBanner banner;
  final void Function(AdBanner) onTap;
  const _BannerSlide({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(banner),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: CachedNetworkImage(
          imageUrl: banner.url,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (_, __) => Container(color: Colors.black12),
          errorWidget: (_, __, ___) => Container(color: Colors.black12),
        ),
      ),
    );
  }
}

class _AdSlide extends StatefulWidget {
  @override
  State<_AdSlide> createState() => _AdSlideState();
}

class _AdSlideState extends State<_AdSlide> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (BuffyService.isPro) return;
    _ad = BannerAd(
      adUnitId: AdMob.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.leaderboard,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
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
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: AdWidget(ad: _ad!),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.onSurface
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
