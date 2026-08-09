import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../../services/service_export.dart';
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) viewModel.maybeShowExitInterstitial();
      },
      child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Immersive Full-Bleed Wallpaper with Pinch-To-Zoom & Ken Burns animation
          InteractiveViewer(
            clipBehavior: Clip.none,
            maxScale: 4.0,
            child: Hero(
              tag: wall.imageUrl,
              child: WallpaperHeroWidget(wall: wall),
            ),
          ),

          // Tap overlay to hide/show UI controls
          GestureDetector(
            onTap: viewModel.toggleInfoUI,
          ),

          // 2. Premium Back Button
          _buildBackBtn(context, viewModel),

          // 3. Floating Glass Action Buttons Column
          if (!viewModel.hideInfoUI)
            _FloatingActionsColumn(wall: wall, viewModel: viewModel),

          // 4. Draggable Scrollable Glass Bottom Sheet
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            bottom: viewModel.hideInfoUI ? -MediaQuery.of(context).size.height * 0.9 : 0,
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: viewModel.hideInfoUI,
              child: DraggableScrollableSheet(
                initialChildSize: 0.23, // ~160dp height collapsed
                minChildSize: 0.23,
                maxChildSize: 0.90,
                builder: (context, scrollController) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF02081C).withOpacity(0.75),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Drag Handle Bar
                              const SizedBox(height: 12),
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
                              const SizedBox(height: 16),

                              // Collapsed State Header Block
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            wall.name,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "By ${wall.designer} • ${wall.category}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Apply Wallpaper Button (Triggers premium bottom sheet)
                                    GestureDetector(
                                      onTap: () {
                                        showApplySheet(context, viewModel, wall);
                                        BuffyService.recordInteraction(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF3603C6).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            )
                                          ]
                                        ),
                                        child: const Text(
                                          "Apply",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),
                              const Divider(height: 1, thickness: 1, color: Colors.white12),
                              const SizedBox(height: 20),

                              // Expanded Content Block
                              // 1. Metadata Chips
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildChip(Icons.center_focus_strong_rounded, viewModel.imageResolution),
                                    _buildChip(Icons.insert_drive_file_rounded, viewModel.imageSize),
                                    _buildChip(Icons.category_rounded, wall.category),
                                    if (wall.isPremium) _buildChip(Icons.star_rounded, "Premium", isPremium: true),
                                    _buildChip(Icons.stay_current_portrait_rounded, "Portrait"),
                                    _buildChip(Icons.hd_rounded, "4K UHD"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 2. Color Palette
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  "Color Palette",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: _colorsUI(viewModel, context),
                              ),

                              const SizedBox(height: 28),

                              // 3. Discovery: Related Wallpapers -> Native Ad
                              // -> More Like This -> Collections -> More
                              // Wallpapers. A manual color-filter tap (via
                              // the palette above) switches to a single
                              // focused "Similar Color Matches" carousel
                              // instead — splitting a deliberate filter
                              // result into two arbitrary halves wouldn't
                              // make sense.
                              if (viewModel.selectedColorFilter != null)
                                _buildColorMatchSection(viewModel, context)
                              else
                                _buildDiscoverySection(viewModel, context),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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

  Widget _colorsListViewUI(List<Color> colors, {required Function(Color) onSelected}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors
          .map((color) {
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
          })
          .toList(),
    );
  }

  Widget _buildChip(IconData icon, String label, {bool isPremium = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPremium
            ? const Color(0xFF3603C6).withOpacity(0.3)
            : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium
              ? const Color(0xFF0BB0E3).withOpacity(0.4)
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
            color: isPremium ? const Color(0xFF0BB0E3) : Colors.white70,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPremium ? const Color(0xFF0BB0E3) : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorMatchSection(ImageViewModel viewModel, BuildContext context) {
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
                onTap: () => viewModel.selectColorFilter(viewModel.selectedColorFilter!),
                child: const Icon(Icons.cancel_rounded, color: Colors.white54, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _wallCarouselRow(viewModel.relatedByColor, context),
      ],
    );
  }

  Widget _buildDiscoverySection(ImageViewModel viewModel, BuildContext context) {
    final related = viewModel.relatedWalls;
    final half = (related.length / 2).ceil();
    final firstHalf = related.take(half).toList();
    final secondHalf = related.length > half ? related.sublist(half) : const <PopularWall>[];
    final collections = locator<HomeViewModel>().data.hotCollections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!BuffyService.isPro && wall.isPremium && viewModel.freeAlternatives.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _sectionHeading("🎁 Free Alternative Wallpapers"),
          ),
          const SizedBox(height: 12),
          _wallCarouselRow(viewModel.freeAlternatives.take(12).toList(), context),
          const SizedBox(height: 24),
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _sectionHeading("✨ Related Wallpapers"),
        ),
        const SizedBox(height: 12),
        _wallCarouselRow(firstHalf, context),
        const SizedBox(height: 24),

        if (!BuffyService.isPro) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: NativeAdCard(aspectRatio: 3.0),
          ),
          const SizedBox(height: 24),
        ],

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
              locator<NavigationService>().navigateToCollectionDetailView(collection: name);
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
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _moreWallpapersButton(BuildContext context) {
    return GestureDetector(
      onTap: () => locator<HomeViewModel>().navigateToAllView(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3603C6).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          "More Wallpapers",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                AnalyticsService.instance.logWallpaperClick(w.id.toString(), 'infinite_discovery');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageView(wall: w),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackBtn(BuildContext context, ImageViewModel viewModel) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      top: viewModel.hideInfoUI ? -200 : 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      viewModel.maybeShowExitInterstitial();
                      Navigator.pop(context);
                    },
                    iconSize: 24,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Premium apply wallpaper bottom sheet options triggerer
  void showApplySheet(BuildContext context, ImageViewModel viewModel, PopularWall wall) {
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
                color: const Color(0xFF02081C).withOpacity(0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                      final canProceed = await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(WallApplyAction.homescreen, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.lock_outline_rounded,
                    title: "Lock Screen",
                    desc: "Set wallpaper on lock screen only",
                    onTap: () async {
                      final canProceed = await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(WallApplyAction.lockscreen, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.phone_android_rounded,
                    title: "Both Screens",
                    desc: "Apply to home and lock screens",
                    onTap: () async {
                      final canProceed = await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(WallApplyAction.both, wall.imageUrl, wall.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ApplyOptionCard(
                    icon: Icons.settings_rounded,
                    title: "Native Apply",
                    desc: "Use system chooser application",
                    onTap: () async {
                      final canProceed = await viewModel.checkProRequirement(context, wall);
                      if (!canProceed) return;
                      if (context.mounted) Navigator.pop(context);
                      viewModel.applyWallpaper(WallApplyAction.native, wall.imageUrl, wall.id);
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
// Floating circular Glass actions (Heart, Share, Download)
// --------------------------------------------------
class _FloatingActionsColumn extends StatelessWidget {
  final PopularWall wall;
  final ImageViewModel viewModel;

  const _FloatingActionsColumn({
    required this.wall,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.28,
      child: Column(
        children: [
          // 1. Favorite
          ViewModelBuilder<FavouriteViewModel>.reactive(
            viewModelBuilder: () => locator<FavouriteViewModel>(),
            disposeViewModel: false,
            builder: (context, model, child) {
              final isFav = model.isFavourite(wall.imageUrl);
              return _CircularGlassAction(
                icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.red : Colors.white,
                onTap: () async {
                  if (!isFav && !BuffyService.isPro) {
                    final response = await locator<DialogService>().showCustomDialog(
                      variant: DialogType.pro,
                      barrierDismissible: false,
                    );
                    if (response?.confirmed != true) return;
                  }
                  isFav
                      ? model.removeFavourite(wall.imageUrl)
                      : locator<HomeViewModel>().addFavourite(wall.imageUrl);
                  if (context.mounted) {
                    BuffyService.recordInteraction(context);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16),
          // 2. Share
          _CircularGlassAction(
            icon: Icons.share_rounded,
            onTap: () {
              SharePlus.instance.share(ShareParams(
                text: "Check out this wallpaper on BuffyWalls: https://play.google.com/store/apps/details?id=com.shadowteam.buffywallsfree"
              ));
            },
          ),
          const SizedBox(height: 16),
          // 3. Download
          _CircularGlassAction(
            icon: viewModel.isWallDownloaded ? Icons.check : Icons.download_rounded,
            color: viewModel.isWallDownloaded ? Colors.green : Colors.white,
            isLoading: viewModel.isWallDownloading,
            onTap: () async {
              final canProceed = await viewModel.checkProRequirement(context, wall);
              if (!canProceed) return;
              viewModel.downloadWallpaper(
                wall.imageUrl,
                "${wall.name}_${wall.id}",
                wall.id,
              );
              BuffyService.recordInteraction(context);
            },
          ),
        ],
      ),
    );
  }
}

class _CircularGlassAction extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const _CircularGlassAction({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.isLoading = false,
  });

  @override
  State<_CircularGlassAction> createState() => _CircularGlassActionState();
}

class _CircularGlassActionState extends State<_CircularGlassAction> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: widget.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                  : Icon(widget.icon, color: widget.color, size: 22),
            ),
          ),
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

class _ApplyOptionCardState extends State<_ApplyOptionCard> with SingleTickerProviderStateMixin {
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
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
