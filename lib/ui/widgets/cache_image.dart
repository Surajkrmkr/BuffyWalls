import 'package:flutter/material.dart';

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'widget_export.dart';

class CacheImage extends StatefulWidget {
  const CacheImage({
    Key? key,
    required this.imageUrl,
    this.fullView = false,
    this.wall,
  }) : super(key: key);

  final String imageUrl;
  final bool fullView;
  final PopularWall? wall;

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  bool _failedPrimary = false;
  bool _failedFallback = false;

  @override
  void didUpdateWidget(CacheImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.wall?.id != widget.wall?.id) {
      _failedPrimary = false;
      _failedFallback = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PopularWall? wall = widget.wall;

    // 1. Full Detail View (Image View)
    if (widget.fullView) {
      final mainUrl = (wall != null && wall.imageUrl.isNotEmpty)
          ? wall.imageUrl
          : widget.imageUrl;

      if (mainUrl.isEmpty || _failedPrimary) {
        return _neutralPlaceholder(context);
      }

      final cacheKey = (wall != null && wall.id != 0)
          ? 'full_${wall.id}'
          : 'full_$mainUrl';

      return CachedNetworkImage(
        imageUrl: mainUrl,
        cacheKey: cacheKey,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        memCacheHeight: 2340,
        placeholder: (context, url) => _skeletonPlaceholder(context),
        errorWidget: (context, url, error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_failedPrimary) {
              setState(() => _failedPrimary = true);
            }
          });
          return _neutralPlaceholder(context);
        },
      );
    }

    // 2. Preview Grid Card (Home, Latest, Explore All, Collections, Related, etc.)
    final primaryThumbUrl = (wall != null && wall.thumbnailUrl.isNotEmpty)
        ? wall.thumbnailUrl
        : widget.imageUrl;

    final fallbackUrl = (wall != null && wall.imageUrl.isNotEmpty)
        ? wall.imageUrl
        : '';

    if (_failedFallback || (primaryThumbUrl.isEmpty && fallbackUrl.isEmpty)) {
      return _neutralPlaceholder(context);
    }

    final activeUrl = _failedPrimary ? fallbackUrl : primaryThumbUrl;
    if (activeUrl.isEmpty) {
      return _neutralPlaceholder(context);
    }

    final String cacheKey;
    if (wall != null && wall.id != 0) {
      cacheKey =
          _failedPrimary ? 'fallback_full_${wall.id}' : 'thumb_${wall.id}';
    } else {
      cacheKey = _failedPrimary ? 'fallback_$activeUrl' : 'thumb_$activeUrl';
    }

    return CachedNetworkImage(
      imageUrl: activeUrl,
      cacheKey: cacheKey,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      memCacheHeight: 700,
      placeholder: (context, url) => _skeletonPlaceholder(context),
      errorWidget: (context, url, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (!_failedPrimary) {
              setState(() => _failedPrimary = true);
            } else if (!_failedFallback) {
              setState(() => _failedFallback = true);
            }
          }
        });
        return _neutralPlaceholder(context);
      },
    );
  }

  Widget _skeletonPlaceholder(BuildContext context) {
    return BuffySkeleton(
      enabled: true,
      effect: pulseEffect(context),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      ),
    );
  }

  Widget _neutralPlaceholder(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 26,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
      ),
    );
  }
}

class BuffyImage extends StatefulWidget {
  final bool fullView;
  final bool showFavIcon;
  final double radius;
  final PopularWall wall;
  final VoidCallback? onTap;
  final Object? heroTag;

  const BuffyImage({
    super.key,
    required this.wall,
    this.fullView = false,
    this.radius = 24,
    this.showFavIcon = true,
    this.onTap,
    this.heroTag,
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
    final effectiveHeroTag = widget.heroTag ?? (widget.wall.imageUrl.isNotEmpty ? widget.wall.imageUrl : null);
    final imageWidget = CacheImage(
      wall: widget.wall,
      // Grid/carousel previews always prefer the
      // compressed thumbnail when one exists — only the
      // full detail view needs the full-resolution image.
      imageUrl: (!widget.fullView && widget.wall.compressUrl.isNotEmpty)
          ? widget.wall.compressUrl
          : widget.wall.imageUrl,
      fullView: widget.fullView,
    );

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
                    if (effectiveHeroTag != null)
                      Hero(
                        tag: effectiveHeroTag,
                        child: imageWidget,
                      )
                    else
                      imageWidget,
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
                        offstage: !widget.showFavIcon,
                        child: ViewModelBuilder<FavouriteViewModel>.reactive(
                          viewModelBuilder: () => locator<FavouriteViewModel>(),
                          disposeViewModel: false,
                          builder: (context, model, child) {
                            final isFavourite = model.isFavourite(widget.wall.imageUrl);
                            return favouriteIcon(
                              onPressed: () async {
                                if (!isFavourite && !BuffyService.isPro) {
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
