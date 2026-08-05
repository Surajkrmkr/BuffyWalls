import 'package:flutter/material.dart';

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'widget_export.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({Key? key, required this.imageUrl, this.fullView = false})
      : super(key: key);
  final String imageUrl;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey,
          )
        : CachedNetworkImage(
            filterQuality: FilterQuality.high,
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline_rounded, color: Colors.red),
            fit: BoxFit.cover,
            memCacheHeight: fullView ? 2340 : 700,
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return BuffySkeleton(
                  enabled: true,
                  effect: pulseEffect(context),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ));
            },
          );
  }
}

class BuffyImage extends StatefulWidget {
  final bool fullView;
  final bool showFavIcon;
  final double radius;
  final PopularWall wall;
  final VoidCallback? onTap;

  const BuffyImage({
    super.key,
    required this.wall,
    this.fullView = false,
    this.radius = 24,
    this.showFavIcon = true,
    this.onTap,
  });

  @override
  State<BuffyImage> createState() => _BuffyImageState();
}

class _BuffyImageState extends State<BuffyImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedToday = widget.wall.isPremium && MonetizationService.isUnlockedToday(widget.wall.id);
    final hasBadge = widget.wall.isHot || widget.wall.isPremium;
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
      onTap: () async {
        if (!BuffyService.isPro && widget.wall.isPremium && !unlockedToday) {
          final response = await locator<DialogService>().showCustomDialog(
            variant: DialogType.pro,
            barrierDismissible: false,
            data: {'wallId': widget.wall.id},
          );
          if (response?.confirmed != true) return;
        }
        if (widget.onTap != null) {
          widget.onTap!.call();
        } else {
          locator<NavigationService>().navigateToImageView(wall: widget.wall);
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final scaleVal = _scaleAnimation.value;
          final shadowBlur = 4.0 + (scaleVal - 1.0) * 300.0;
          final shadowOffset = 2.0 + (scaleVal - 1.0) * 150.0;

          return Transform.scale(
            scale: scaleVal,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12 + (scaleVal - 1.0) * 2.0),
                    blurRadius: shadowBlur,
                    offset: Offset(0, shadowOffset),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.radius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: widget.wall.imageUrl,
                      child: CacheImage(
                        // Grid/carousel previews always prefer the
                        // compressed thumbnail when one exists — only the
                        // full detail view needs the full-resolution image.
                        imageUrl: (!widget.fullView && widget.wall.compressUrl.isNotEmpty)
                            ? widget.wall.compressUrl
                            : widget.wall.imageUrl,
                        fullView: widget.fullView,
                      ),
                    ),
                    if (hasBadge)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: widget.wall.isPremium
                            ? (unlockedToday ? const UnlockedBadge() : const PremiumBadge())
                            : const HotBadge(),
                      ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Offstage(
                        child: ViewModelBuilder<FavouriteViewModel>.reactive(
                          viewModelBuilder: () => locator<FavouriteViewModel>(),
                          disposeViewModel: false,
                          builder: (context, model, child) {
                            final isFavourite = model.isFavourite(widget.wall.imageUrl);
                            return favouriteIcon(
                              onPressed: () async {
                                if (!BuffyService.isPro) {
                                  final response = await locator<DialogService>().showCustomDialog(
                                    variant: DialogType.pro,
                                    barrierDismissible: false,
                                  );
                                  if (response?.confirmed != true) return;
                                }
                                isFavourite
                                    ? model.removeFavourite(widget.wall.imageUrl)
                                    : locator<HomeViewModel>().addFavourite(widget.wall.imageUrl);
                              },
                              isFavourite: isFavourite,
                            );
                          },
                        ),
                        offstage: !widget.showFavIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
}

Widget favouriteIcon(
    {required bool isFavourite, required Function() onPressed}) {
  return IconButton.filledTonal(
    style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2)),
    onPressed: onPressed,
    icon: Icon(
        isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
    color: isFavourite ? Colors.red : Colors.white,
  );
}

Widget showTag({bool isPro = false}) {
  return Container(
    height: 25,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: isPro
              ? [const Color(0xFF0BB0E3), const Color(0xFF3603C6)]
              : [const Color(0xFFFF0000), const Color(0xFFFF8A00)]),
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        Icon(
          isPro ? Icons.verified_rounded : Icons.local_fire_department_rounded,
          color: backgroundLight,
          size: 16,
        ),
        horizontalSpaceTiny,
        Text(isPro ? "Pro" : "Hot",
            style: const TextStyle(color: backgroundLight, fontSize: 12)),
      ],
    ),
  );
}
