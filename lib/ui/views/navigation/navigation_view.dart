import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicatorWidget(
          onRefresh: () async => await viewModel.refresh(),
          child: IndexedStack(
            index: viewModel.currentIndex,
            children: const [
              HomeView(),
              CategoryView(),
              FavouriteView(),
            ],
          ),
        ),
      ),
      // The banner stays docked at all times; only the nav bar tucks away
      // while scrolling down, so scrolling never costs banner impressions.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!BuffyService.isPro) const AdsWidget(bottomPadding: 0),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: viewModel.navBarVisible
                ? Container(
                    decoration: BoxDecoration(
                      color: dark ? backgroundDark : backgroundLight,
                      border: Border(
                        top: BorderSide(
                          color: (dark ? Colors.white : Colors.black)
                              .withOpacity(0.07),
                        ),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        height: 62,
                        child: Row(
                          children: navs.asMap().entries.map((entry) {
                            final nav = entry.value;
                            return Expanded(
                              child: SleekNavBarItem(
                                isSelected:
                                    entry.key == viewModel.currentIndex,
                                icon: nav.icon,
                                activeIcon: nav.activeIcon,
                                label: nav.label,
                                onTap: () => viewModel.setIndex(entry.key),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
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

class SleekNavBarItem extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;

  const SleekNavBarItem({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final color = isSelected ? onSurface : onSurface.withOpacity(0.45);
    return Pressable(
      onTap: onTap,
      scale: 0.92,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Soft gold pill grows behind the active icon.
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: isSelected ? 58 : 34,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected
                  ? gold.withOpacity(dark ? 0.2 : 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                size: 23,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 11,
              letterSpacing: 0.2,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

final List<BuffyNav> navs = [
  const BuffyNav(
      icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
  const BuffyNav(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Categories'),
  const BuffyNav(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favourites'),
];

class BuffyNav {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const BuffyNav({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
