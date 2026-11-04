import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'onboard_viewmodel.dart';

/// Single-screen welcome: a slow, tilted wall of wallpapers drifting behind
/// a short pitch and one button.
class OnboardView extends StackedView<OnboardViewModel> {
  const OnboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardViewModel viewModel,
    Widget? child,
  ) {
    final size = MediaQuery.of(context).size;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final colW = (size.width - 48) / 3;
    final urls = viewModel.onBoardBanners;

    List<String> slice(int col) {
      if (urls.isEmpty) return const [];
      final out = <String>[];
      for (var i = col; i < urls.length; i += 3) {
        out.add(urls[i]);
      }
      return out;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tilted drifting wall.
          Positioned(
            left: -30,
            right: -30,
            top: -60,
            height: size.height * 0.78,
            child: Transform.rotate(
              angle: -math.pi / 22,
              child: OverflowBox(
                maxWidth: size.width + 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (c) => Padding(
                      padding: EdgeInsets.only(left: c == 0 ? 0 : 12),
                      child: _Drift(
                        width: colW,
                        urls: slice(c),
                        reverse: c.isOdd,
                        loading: viewModel.isBusy,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Fade into the page colour.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.38, 0.66, 0.82],
                  colors: [
                    bg.withOpacity(0.55),
                    bg.withOpacity(0),
                    bg.withOpacity(0.92),
                    bg,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: Column(
                children: [
                  const Spacer(),
                  Reveal(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: gold.withOpacity(0.7)),
                      ),
                      child: const Text(
                        '4K  ·  HAND-MADE  ·  FREE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                          color: gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Reveal(
                    delay: const Duration(milliseconds: 120),
                    child: Text(
                      'Wallpapers\nworth keeping.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        height: 1.02,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.8,
                        color: onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Reveal(
                    delay: const Duration(milliseconds: 220),
                    child: Text(
                      'Fresh 4K art for your home and lock screen,\nadded every week.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Reveal(
                    delay: const Duration(milliseconds: 320),
                    child: Pressable(
                      scale: 0.97,
                      onTap: viewModel.onEnterTapped,
                      child: Container(
                        height: 58,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: onSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Get started',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: bg,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                size: 20, color: bg),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Go Pro any time for no ads and every wallpaper.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: onSurface.withOpacity(0.42),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  OnboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnboardViewModel();

  @override
  void onViewModelReady(OnboardViewModel viewModel) => viewModel.getBanners();
}

/// One column of wallpaper cards that loops vertically forever.
class _Drift extends StatefulWidget {
  final double width;
  final List<String> urls;
  final bool reverse;
  final bool loading;
  const _Drift({
    required this.width,
    required this.urls,
    required this.reverse,
    required this.loading,
  });

  @override
  State<_Drift> createState() => _DriftState();
}

class _DriftState extends State<_Drift> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 50),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemH = widget.width * 1.9;
    const gap = 12.0;
    final count = widget.urls.isEmpty ? 6 : widget.urls.length;
    final cycle = (itemH + gap) * count;
    // Two copies back to back so the loop is seamless.
    final items = List.generate(count * 2, (i) {
      final url = widget.urls.isEmpty ? '' : widget.urls[i % count];
      return Padding(
        padding: const EdgeInsets.only(bottom: gap),
        child: SizedBox(
          width: widget.width,
          height: itemH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: url.isEmpty
                ? (widget.loading
                    ? const SkelBox(radius: 20)
                    : ColoredBox(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? surfaceDark
                            : surfaceLight))
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: (_, __) => const SkelBox(radius: 20),
                    errorWidget: (_, __, ___) => ColoredBox(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? surfaceDark
                          : surfaceLight,
                    ),
                  ),
          ),
        ),
      );
    });

    return SizedBox(
      width: widget.width,
      child: ShimmerHost(
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: 0,
            maxHeight: double.infinity,
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, child) {
                final t = widget.reverse ? 1 - _c.value : _c.value;
                // Reverse columns start half a cycle in so the wall is
                // staggered from the first frame.
                final dy = -(((t + (widget.reverse ? 0.35 : 0)) % 1) * cycle);
                return Transform.translate(offset: Offset(0, dy), child: child);
              },
              child: Column(children: items),
            ),
          ),
        ),
      ),
    );
  }
}
