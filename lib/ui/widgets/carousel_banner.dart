import 'dart:async';
import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
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
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 90,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return _BannerSlide(
                banner: banner,
                onTap: widget.onTap,
              );
            },
          ),
        ),
        verticalSpaceSmall,
        _DotsIndicator(count: widget.banners.length, current: _currentPage),
      ],
    );
  }
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
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
