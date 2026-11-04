import 'package:flutter/material.dart';

import 'dart:ui';

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'cache_image.dart';
import 'motion.dart';
import 'skeletonizer.dart';
import 'toast.dart';

/// Bottom sheet letting the user pick *which* still-locked premium
/// wallpaper they want to unlock, instead of one being auto-picked for
/// them. Shared by [RewardBanner] and [BuffyService]'s first-launch
/// reward flow so both offer the same choice.
Future<void> showPremiumWallpaperPicker(
  BuildContext context, {
  required void Function(PopularWall wall) onSelected,
}) {
  final walls = locator<HomeViewModel>()
      .premiumWallList
      .where((w) => !MonetizationService.isUnlockedToday(w.id))
      .toList();

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    builder: (sheetContext) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.75),
            decoration: BoxDecoration(
              color: backgroundDark.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Choose a wallpaper to unlock",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Unlocked free for the next 24 hours.",
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: walls.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            "No premium wallpapers left to unlock right now.",
                            style: TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: walls.length,
                          itemBuilder: (context, index) {
                            final wall = walls[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(sheetContext);
                                onSelected(wall);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CacheImage(
                                      imageUrl: wall.compressUrl.isNotEmpty ? wall.compressUrl : wall.imageUrl,
                                    ),
                                    Positioned(
                                      left: 6,
                                      right: 6,
                                      bottom: 6,
                                      child: Text(
                                        wall.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Small muted "Ad" pill — same shape/size as [HotBadge]/[PremiumBadge] in
/// `premium_widgets.dart` (12px radius, 8/4 padding) but deliberately
/// neutral, not a gradient, so it reads as a disclosure label rather than
/// a promo.
class AdBadge extends StatelessWidget {
  const AdBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: const Text(
        'Ad',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Green "Unlocked" pill shown on a premium [BuffyImage] once it's been
/// unlocked for the day via [MonetizationService.isUnlockedToday] — visible
/// positive feedback that the reward actually took effect.
class UnlockedBadge extends StatelessWidget {
  const UnlockedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: gold.withOpacity(0.6), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open_rounded, color: gold, size: 11),
          SizedBox(width: 3),
          Text(
            'UNLOCKED',
            style: TextStyle(
              color: gold,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic shimmer filler for any ad surface that's loading or failed to
/// load. Always fills the space it's given — an ad slot must never
/// collapse to zero, or neighbouring content would jump when it resolves.
class AdPlaceholder extends StatelessWidget {
  final double borderRadius;
  const AdPlaceholder({super.key, this.borderRadius = 24});

  @override
  Widget build(BuildContext context) {
    return BuffySkeleton(
      enabled: true,
      effect: pulseEffect(context),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class BannerAdCard extends StatefulWidget {
  final String? adUnitId;
  final AdSize adSize;

  const BannerAdCard({
    super.key,
    this.adUnitId,
    this.adSize = AdSize.banner,
  });

  @override
  State<BannerAdCard> createState() => _BannerAdCardState();
}

class _BannerAdCardState extends State<BannerAdCard> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (!BuffyService.isPro) {
      _loadBanner(widget.adUnitId ?? AdMob.bannerAd2UnitId);
    }
  }

  void _loadBanner(String unitId) {
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: unitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _failed = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          // If bannerAd2UnitId failed, try fallback to primary bannerAdUnitId
          if (unitId != AdMob.bannerAdUnitId) {
            _loadBanner(AdMob.bannerAdUnitId);
          } else {
            if (mounted) setState(() => _failed = true);
          }
        },
      ),
    );
    _bannerAd!.load().catchError((_) {
      _bannerAd?.dispose();
      _bannerAd = null;
      if (unitId != AdMob.bannerAdUnitId) {
        _loadBanner(AdMob.bannerAdUnitId);
      } else {
        if (mounted) setState(() => _failed = true);
      }
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (BuffyService.isPro) return const SizedBox.shrink();

    if (_failed) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: widget.adSize.height.toDouble() + 16,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isLoaded && _bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AdBadge(),
                const SizedBox(width: 8),
                Text(
                  "Sponsored",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// "🎁 Daily Reward" banner — replaces the old `RewardAdCard`. Shows a
/// 0/3..3/3 milestone (purely a gamified nudge, not a hard cap — see
/// [MonetizationService]) and a one-tap "Watch Video" CTA that unlocks a
/// specific premium wallpaper immediately, no coins/points/redemption step.
class RewardBanner extends StatelessWidget {
  const RewardBanner({super.key});

  void _watchVideo(BuildContext context) {
    final homeModel = locator<HomeViewModel>();
    final hasAnyLocked = homeModel.premiumWallList
        .any((w) => !MonetizationService.isUnlockedToday(w.id));
    if (!hasAnyLocked) {
      showToast("No premium wallpapers left to unlock right now.");
      return;
    }
    // Let the user pick which wallpaper they're unlocking before they
    // commit to watching the ad.
    showPremiumWallpaperPicker(
      context,
      onSelected: (target) {
        locator<AdsService>().loadRewardedAd(
          navigateBack: false,
          onRewarded: () async {
            MonetizationService.recordVideoWatched();
            MonetizationService.unlockToday(target.id);
            showToast("🎉 '${target.name}' unlocked!");
            homeModel.notifyRewardStateChanged();
            await locator<NavigationService>().navigateToImageView(wall: target);
            homeModel.notifyRewardStateChanged();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = MonetizationService.milestoneProgress;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
        decoration: BoxDecoration(
          color: dark ? surfaceDark : surfaceLight,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: gold.withOpacity(dark ? 0.35 : 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY REWARD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: dark ? gold : goldDeep,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Unlock a premium\nwallpaper for today',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ...List.generate(MonetizationService.milestoneTarget, (i) {
                        final filled = i < progress;
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 20,
                            height: 5,
                            decoration: BoxDecoration(
                              color: filled
                                  ? gold
                                  : onSurface.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '$progress/${MonetizationService.milestoneTarget} today',
                        style: TextStyle(
                          fontSize: 12,
                          color: onSurface.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Pressable(
                  onTap: () => _watchVideo(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: premiumGradient),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: onGold, size: 18),
                        SizedBox(width: 2),
                        Text(
                          'Watch',
                          style: TextStyle(
                            color: onGold,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Pressable(
                  onTap: () => openLink(Links.buffyPaid),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'or get Pro',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum EditorialVariant { featuredCollection, recommendedForYou, editorsChoice, seasonal }

/// Replaces [RewardBanner] once the daily milestone is reached — "never
/// leave empty space". Rotates daily (by day-of-year) across a small set
/// of editorial framings, all sourced from data [HomeViewModel] already
/// has loaded — no backend calls.
class EditorialPromotionCard extends StatelessWidget {
  const EditorialPromotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeModel = locator<HomeViewModel>();
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final variant = EditorialVariant.values[dayOfYear % EditorialVariant.values.length];

    late String title;
    late String subtitle;
    late VoidCallback onTap;

    switch (variant) {
      case EditorialVariant.featuredCollection:
      case EditorialVariant.seasonal:
        final collections = homeModel.data.hotCollections;
        final name = collections.isNotEmpty ? collections.first : "Curated Picks";
        title = variant == EditorialVariant.seasonal ? "🍂 Seasonal Collection" : "📚 Featured Collection";
        subtitle = name;
        onTap = () => homeModel.navigateToCollectionDetailView(name);
        break;
      case EditorialVariant.recommendedForYou:
        title = "❤️ Recommended For You";
        subtitle = "Picks based on what you've viewed";
        onTap = homeModel.navigateToAllView;
        break;
      case EditorialVariant.editorsChoice:
        title = "✨ Editor's Choice";
        subtitle = "Hand-picked wallpapers worth a look";
        onTap = homeModel.navigateToTrendingView;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 125),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
