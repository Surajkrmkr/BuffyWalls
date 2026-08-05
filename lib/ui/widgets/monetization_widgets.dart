import 'package:flutter/material.dart';

import 'dart:ui';

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'cache_image.dart';
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
              color: const Color(0xFF02081C).withOpacity(0.9),
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
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open_rounded, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            'UNLOCKED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
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

/// A native ad rendered inside the same card frame as [BuffyImage]
/// (corner radius, shadow, card background) so it keeps the grid's rhythm.
///
/// Note on native ad templates: AdMob's `NativeTemplateStyle` is a
/// pre-built layout (small/medium), not an arbitrary-aspect-ratio canvas —
/// it centers itself within whatever frame it's given rather than
/// stretching to fill a tall portrait cell pixel-for-pixel. `medium` is
/// used here (vs. the compact `small` template) since it tolerates a
/// taller frame better. The card *chrome* (radius/shadow/background)
/// always matches; the ad's internal content adapts to what the SDK
/// allows — that's the realistic ceiling for "blending" a native ad.
class NativeAdCard extends StatefulWidget {
  final double aspectRatio;
  final double borderRadius;
  const NativeAdCard({super.key, this.aspectRatio = 0.6, this.borderRadius = 24});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _ad;
  bool _isLoaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (!BuffyService.isPro) _loadAd();
  }

  void _loadAd() {
    _ad = NativeAd(
      adUnitId: AdMob.nativeAdUnitId,
      factoryId: null,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.transparent,
      ),
      listener: NativeAdListener(
        // Analytics hook: a future "native ad impression" event belongs
        // here, once loaded and actually shown on screen.
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) setState(() => _failed = true);
        },
        // Analytics hook: a future "native ad click" event belongs here.
        onAdClicked: (ad) {},
      ),
    );
    _ad!.load().catchError((_) {
      _ad?.dispose();
      _ad = null;
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (BuffyService.isPro) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_isLoaded && _ad != null)
                Center(child: AdWidget(ad: _ad!))
              else if (_failed)
                Center(
                  child: Icon(
                    Icons.ads_click_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                    size: 24,
                  ),
                )
              else
                AdPlaceholder(borderRadius: widget.borderRadius),
              const Positioned(top: 10, left: 10, child: AdBadge()),
            ],
          ),
        ),
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
          onRewarded: () {
            MonetizationService.recordVideoWatched();
            MonetizationService.unlockToday(target.id);
            showToast("🎉 '${target.name}' unlocked!");
            homeModel.notifyRewardStateChanged();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = MonetizationService.milestoneProgress;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 125),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3603C6), Color(0xFF0BB0E3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3603C6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.15,
                child: Icon(Icons.card_giftcard_rounded, size: 160, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "DAILY REWARD",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Unlock Premium Wallpapers",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(MonetizationService.milestoneTarget, (i) {
                            final filled = i < progress;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Container(
                                width: 22,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: filled ? Colors.white : Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$progress/${MonetizationService.milestoneTarget} unlocked today",
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _watchVideo(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3603C6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      "▶ Watch Video",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
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
