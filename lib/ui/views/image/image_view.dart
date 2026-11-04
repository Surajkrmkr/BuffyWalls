import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class ImageView extends StackedView<ImageViewModel> {
  final PopularWall wall;
  const ImageView({Key? key, required this.wall}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ImageViewModel viewModel,
    Widget? child,
  ) {
    final hide = viewModel.hideInfoUI;
    final previewing = viewModel.previewMode != 0;
    final chromeVisible = !hide;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BuffyService.isPro
          ? null
          : const SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [AdsWidget(bottomPadding: 0)],
              ),
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed wallpaper: pinch to zoom, tap to hide the controls.
          InteractiveViewer(
            clipBehavior: Clip.none,
            maxScale: 4.0,
            child: Hero(
              tag: wall.imageUrl,
              child: WallpaperHeroWidget(wall: wall),
            ),
          ),
          GestureDetector(onTap: viewModel.toggleInfoUI),

          // Lock / home screen mock-up so the wallpaper can be judged in place.
          IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: switch (viewModel.previewMode) {
                1 => const _PhonePreview(key: ValueKey('lock'), lock: true),
                2 => const _PhonePreview(key: ValueKey('home'), lock: false),
                _ => const SizedBox.shrink(key: ValueKey('none')),
              },
            ),
          ),

          // Scrims keep the controls legible on any artwork.
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: chromeVisible && !previewing ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.18, 0.62, 1],
                    colors: [
                      Color(0x99000000),
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top bar: back on the left, preview / favourite / share on the right.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: AnimatedSlide(
                // The bar sits below the status bar, so slide it by more than
                // its own height and fade it, otherwise the buttons stay
                // partly on screen.
                offset: hide ? const Offset(0, -2.6) : Offset.zero,
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: hide ? 0 : 1,
                  duration: const Duration(milliseconds: 220),
                  child: IgnorePointer(
                    ignoring: hide,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                      child: Row(
                        children: [
                          _GlassButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          _GlassButton(
                            icon: switch (viewModel.previewMode) {
                              1 => Icons.lock_outline_rounded,
                              2 => Icons.grid_view_rounded,
                              _ => Icons.phone_iphone_rounded,
                            },
                            active: previewing,
                            onTap: viewModel.cyclePreview,
                          ),
                          const SizedBox(width: 10),
                          ViewModelBuilder<FavouriteViewModel>.reactive(
                            viewModelBuilder: () =>
                                locator<FavouriteViewModel>(),
                            disposeViewModel: false,
                            builder: (context, model, child) {
                              final isFav = model.isFavourite(wall.imageUrl);
                              return _GlassButton(
                                icon: isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFav ? ember : Colors.white,
                                onTap: () async {
                                  if (!isFav && !BuffyService.isPro) {
                                    final response =
                                        await locator<DialogService>()
                                            .showCustomDialog(
                                      variant: DialogType.pro,
                                      barrierDismissible: false,
                                    );
                                    if (response?.confirmed != true) return;
                                  }
                                  isFav
                                      ? model.removeFavourite(wall.imageUrl)
                                      : locator<HomeViewModel>()
                                          .addFavourite(wall.imageUrl);
                                  if (context.mounted) {
                                    BuffyService.recordInteraction(context);
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          _GlassButton(
                            icon: Icons.ios_share_rounded,
                            onTap: () => SharePlus.instance.share(ShareParams(
                              text:
                                  'Check out "${wall.name}" on BuffyWalls: ${Links.buffyFree}',
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom dock: what it is, then Download and Apply.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: AnimatedSlide(
                offset: hide || previewing ? const Offset(0, 1.3) : Offset.zero,
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: hide || previewing ? 0 : 1,
                  duration: const Duration(milliseconds: 240),
                  child: GestureDetector(
                    onVerticalDragEnd: (d) {
                      if ((d.primaryVelocity ?? 0) < -250) {
                        _openDetails(context, viewModel);
                      }
                    },
                    child: _Dock(
                      wall: wall,
                      viewModel: viewModel,
                      onApply: () {
                        showApplySheet(context, viewModel, wall);
                        BuffyService.recordInteraction(context);
                      },
                      onDownload: () async {
                        final ok =
                            await viewModel.checkProRequirement(context, wall);
                        if (!ok) return;
                        viewModel.downloadWallpaper(
                          wall.imageUrl,
                          '${wall.name}_${wall.id}',
                          wall.id,
                        );
                        if (context.mounted) {
                          BuffyService.recordInteraction(context);
                        }
                      },
                      onDetails: () => _openDetails(context, viewModel),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Everything secondary lives in a sheet that rises over the wallpaper:
  /// specs, palette, then more wallpapers to keep browsing.
  void _openDetails(BuildContext context, ImageViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.66,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, controller) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Container(
            color: backgroundDark,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) => ListView(
                controller: controller,
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      wall.name,
                      style: const TextStyle(
                        fontSize: 26,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'By ${wall.designer}  ·  ${wall.category}',
                      style: const TextStyle(
                          fontSize: 13.5, color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(Icons.center_focus_strong_rounded,
                            viewModel.imageResolution),
                        _buildChip(Icons.insert_drive_file_rounded,
                            viewModel.imageSize),
                        _buildChip(Icons.category_rounded, wall.category),
                        if (wall.isPremium)
                          _buildChip(Icons.star_rounded, 'Premium',
                              isPremium: true),
                        _buildChip(Icons.hd_rounded, '4K UHD'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _sectionHeading('Colour palette'),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Tap a swatch to copy its code',
                      style: TextStyle(fontSize: 12.5, color: Colors.white38),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _colorsUI(viewModel, context),
                  ),
                  const SizedBox(height: 30),
                  if (viewModel.selectedColorFilter != null)
                    _buildColorMatchSection(viewModel, context)
                  else
                    _buildDiscoverySection(viewModel, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorsUI(ImageViewModel model, BuildContext context) {
    final List<Color> colors = model.isBusy
        ? List.generate(6, (index) => Colors.black38)
        : model.colorSwatches;
    return BuffySkeleton(
      enabled: model.isBusy,
      effect: pulseEffect(context),
      child: _colorsListViewUI(colors, onSelected: (color) {
        model.copyColorCode(color);
      }),
    );
  }

  Widget _colorsListViewUI(List<Color> colors,
      {required Function(Color) onSelected}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onSelected(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChip(IconData icon, String label, {bool isPremium = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isPremium ? gold.withOpacity(0.3) : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium
              ? gold.withOpacity(0.4)
              : Colors.white.withOpacity(0.08),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPremium ? gold : Colors.white70,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPremium ? gold : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorMatchSection(
      ImageViewModel viewModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              _sectionHeading("🎨 Similar Color Matches"),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    viewModel.selectColorFilter(viewModel.selectedColorFilter!),
                child: const Icon(Icons.cancel_rounded,
                    color: Colors.white54, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _wallCarouselRow(viewModel.relatedByColor, context),
      ],
    );
  }

  Widget _buildDiscoverySection(
      ImageViewModel viewModel, BuildContext context) {
    final related = viewModel.relatedWalls;
    final half = (related.length / 2).ceil();
    final firstHalf = related.take(half).toList();
    final secondHalf =
        related.length > half ? related.sublist(half) : const <PopularWall>[];
    final collections = locator<HomeViewModel>().data.hotCollections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!BuffyService.isPro &&
            wall.isPremium &&
            viewModel.freeAlternatives.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _sectionHeading("🎁 Free Alternative Wallpapers"),
          ),
          const SizedBox(height: 12),
          _wallCarouselRow(
              viewModel.freeAlternatives.take(12).toList(), context),
          const SizedBox(height: 24),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _sectionHeading("✨ Related Wallpapers"),
        ),
        const SizedBox(height: 12),
        _wallCarouselRow(firstHalf, context),
        const SizedBox(height: 12),
        const NativeFeedAd(compact: true, forceDark: true),
        const SizedBox(height: 12),
        if (secondHalf.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _sectionHeading("🔎 More Like This"),
          ),
          const SizedBox(height: 12),
          _wallCarouselRow(secondHalf, context),
          const SizedBox(height: 24),
        ],
        if (collections.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _sectionHeading("📚 Collections"),
          ),
          const SizedBox(height: 12),
          RelatedChipsRow(
            labels: collections,
            onTap: (name) {
              AnalyticsService.instance.logCollectionClick(name);
              locator<NavigationService>()
                  .navigateToCollectionDetailView(collection: name);
            },
          ),
          const SizedBox(height: 24),
        ],
        Center(child: _moreWallpapersButton(context)),
      ],
    );
  }

  Widget _sectionHeading(String text) {
    return Text(
      text.replaceFirst(RegExp(r'^[^A-Za-z0-9]+'), '').trim(),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: Colors.white.withOpacity(0.92),
      ),
    );
  }

  Widget _moreWallpapersButton(BuildContext context) {
    return GestureDetector(
      onTap: () => locator<HomeViewModel>().navigateToAllView(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: premiumGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          "More wallpapers",
          style: TextStyle(
              color: onGold, fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }

  Widget _wallCarouselRow(List<PopularWall> walls, BuildContext context) {
    if (walls.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Text(
          "No recommendations available.",
          style: TextStyle(color: Colors.white30, fontSize: 13),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: walls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final w = walls[index];
          return SizedBox(
            width: 108,
            child: BuffyImage(
              wall: w,
              radius: 16,
              heroTag: 'related_${index}_${w.imageUrl}',
              onTap: () {
                AnalyticsService.instance
                    .logWallpaperClick(w.id.toString(), 'infinite_discovery');
                final nav = Navigator.of(context);
                nav.pop(); // close the details sheet
                nav.pushReplacement(
                  MaterialPageRoute(builder: (_) => ImageView(wall: w)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Premium apply wallpaper bottom sheet options triggerer
  void showApplySheet(
      BuildContext context, ImageViewModel viewModel, PopularWall wall) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundDark.withOpacity(0.85),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Apply Wallpaper",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Choose where you want to apply this wallpaper.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ApplyOptionCard(
                    icon: Icons.home_rounded,
                    title: "Home Screen",
                    desc: "Set wallpaper on home screen only",
                    onTap: () async {
                      final canProceed =
                          await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(
                          WallApplyAction.homescreen, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.lock_outline_rounded,
                    title: "Lock Screen",
                    desc: "Set wallpaper on lock screen only",
                    onTap: () async {
                      final canProceed =
                          await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(
                          WallApplyAction.lockscreen, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.phone_android_rounded,
                    title: "Both Screens",
                    desc: "Apply to home and lock screens",
                    onTap: () async {
                      final canProceed =
                          await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(
                          WallApplyAction.both, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.settings_rounded,
                    title: "Native Apply",
                    desc: "Use system chooser application",
                    onTap: () async {
                      final canProceed =
                          await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(
                          WallApplyAction.native, wall.imageUrl, wall.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  ImageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ImageViewModel();

  @override
  void onViewModelReady(ImageViewModel viewModel) {
    ScreenSecurityService.enableSecure();
    BuffyService.addToHistory(wall);
    viewModel.logScreenView(wall.name);
    viewModel.checkIfWallDownloaded("${wall.name}_${wall.id}");
    viewModel.getColorPalette(wall.compressUrl);
    viewModel.getImgDetails(wall.imageUrl);
    viewModel.loadInterstitialAd();
    viewModel.loadRelated(wall);
  }

  @override
  void onDispose(ImageViewModel viewModel) {
    ScreenSecurityService.disableSecure();
    super.onDispose(viewModel);
  }
}

// --------------------------------------------------
// WallpaperHeroWidget (static full-bleed background image)
// --------------------------------------------------
class WallpaperHeroWidget extends StatelessWidget {
  final PopularWall wall;
  const WallpaperHeroWidget({super.key, required this.wall});

  @override
  Widget build(BuildContext context) {
    return CacheImage(
      wall: wall,
      imageUrl: wall.imageUrl,
      fullView: true,
    );
  }
}

// --------------------------------------------------
// Round glass button used in the top bar
// --------------------------------------------------
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool active;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: 0.88,
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? gold : Colors.black.withOpacity(0.35),
              border: Border.all(
                color: Colors.white.withOpacity(active ? 0 : 0.16),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(
                icon,
                key: ValueKey(icon),
                size: 21,
                color: active ? onGold : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Bottom dock: name, badges, Download + Apply
// --------------------------------------------------
class _Dock extends StatelessWidget {
  final PopularWall wall;
  final ImageViewModel viewModel;
  final VoidCallback onApply;
  final VoidCallback onDownload;
  final VoidCallback onDetails;

  const _Dock({
    required this.wall,
    required this.viewModel,
    required this.onApply,
    required this.onDownload,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final downloaded = viewModel.isWallDownloaded;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 14, 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wall.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${wall.designer}  ·  ${wall.category}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    if (wall.isPremium) ...[
                      const SizedBox(width: 10),
                      const PremiumBadge(),
                    ] else if (wall.isHot) ...[
                      const SizedBox(width: 10),
                      const HotBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Pressable(
                      scale: 0.9,
                      onTap: onDownload,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.14)),
                        ),
                        child: viewModel.isWallDownloading
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.2, color: Colors.white),
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Icon(
                                  downloaded
                                      ? Icons.check_rounded
                                      : Icons.download_rounded,
                                  key: ValueKey(downloaded),
                                  color: downloaded
                                      ? const Color(0xFF6BD99A)
                                      : Colors.white,
                                  size: 24,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Pressable(
                        scale: 0.97,
                        onTap: onApply,
                        child: Container(
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient:
                                const LinearGradient(colors: premiumGradient),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'Apply wallpaper',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: onGold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Pressable(
                      scale: 0.9,
                      onTap: onDetails,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.14)),
                        ),
                        child: const Icon(Icons.keyboard_arrow_up_rounded,
                            color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Lock / home screen mock-up shown over the wallpaper
// --------------------------------------------------
class _PhonePreview extends StatelessWidget {
  final bool lock;
  const _PhonePreview({super.key, required this.lock});

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final time =
        '${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')}';
    final date =
        '${_days[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}';
    const shadow = [Shadow(color: Color(0x66000000), blurRadius: 16)];

    return SafeArea(
      child: lock
          ? Column(
              children: [
                const SizedBox(height: 74),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 96,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -4,
                    color: Colors.white,
                    shadows: shadow,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: shadow,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 0, 36, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final i in const [
                        Icons.flashlight_on_rounded,
                        Icons.photo_camera_rounded
                      ])
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Icon(i, color: Colors.white, size: 24),
                        ),
                    ],
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 26,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.82,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        20,
                        (_) => Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withOpacity(0.22),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              width: 34,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.black.withOpacity(0.28),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (_) => Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.26),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// --------------------------------------------------
// _ApplyOptionCard Option layout
// --------------------------------------------------
class _ApplyOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const _ApplyOptionCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  State<_ApplyOptionCard> createState() => _ApplyOptionCardState();
}

class _ApplyOptionCardState extends State<_ApplyOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse().then((_) => widget.onTap()),
        onTapCancel: () => _controller.reverse(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white38, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
