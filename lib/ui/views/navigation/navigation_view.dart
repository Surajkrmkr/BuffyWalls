import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class NavigationView extends StackedView<NavigationViewModel> {
  const NavigationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NavigationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      extendBody: true, // Allows content to flow behind the floating dock
      body: SafeArea(
        child: RefreshIndicatorWidget(
          onRefresh: () async => await viewModel.refresh(),
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: viewModel.currentIndex,
                  children: const [
                    HomeView(),
                    CategoryView(),
                    FavouriteView(),
                  ],
                ),
              ),
              const AdsWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: viewModel.navBarVisible
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 32, right: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF02081C).withOpacity(0.7)
                            : Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: navs.asMap().entries.map((entry) {
                          final index = entry.key;
                          final nav = entry.value;
                          final isSelected = index == viewModel.currentIndex;
                          return SleekNavBarItem(
                            isSelected: isSelected,
                            iconPath: nav.iconPath,
                            activeIconPath: nav.activeIconPath,
                            onTap: () => viewModel.setIndex(index),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  NavigationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      locator<NavigationViewModel>();

  @override
  void onViewModelReady(NavigationViewModel viewModel) {
    viewModel.hideNavbar();
  }
}

class SleekNavBarItem extends StatefulWidget {
  final bool isSelected;
  final String iconPath;
  final String activeIconPath;
  final VoidCallback onTap;

  const SleekNavBarItem({
    super.key,
    required this.isSelected,
    required this.iconPath,
    required this.activeIconPath,
    required this.onTap,
  });

  @override
  State<SleekNavBarItem> createState() => _SleekNavBarItemState();
}

class _SleekNavBarItemState extends State<SleekNavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.15)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.15, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 50),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant SleekNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: widget.isSelected
            ? _scaleAnimation
            : const AlwaysStoppedAnimation(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BuffySvgs.icon(
                path:
                    widget.isSelected ? widget.activeIconPath : widget.iconPath,
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: widget.isSelected ? 16 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final List<BuffyNav> navs = [
  const BuffyNav(
      iconPath: Svgs.home, label: 'Home', activeIconPath: Svgs.homeFilled),
  const BuffyNav(
      iconPath: Svgs.category,
      label: 'Categories',
      activeIconPath: Svgs.categoryfilled),
  const BuffyNav(
      iconPath: Svgs.favorite,
      label: 'Favourite',
      activeIconPath: Svgs.favoriteFilled),
];

class BuffyNav {
  final String iconPath;
  final String label;
  final String activeIconPath;
  const BuffyNav({
    required this.iconPath,
    required this.label,
    required this.activeIconPath,
  });
}
