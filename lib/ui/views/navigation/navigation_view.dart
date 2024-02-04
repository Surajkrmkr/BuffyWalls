import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
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
      body: SafeArea(
        child: RefreshIndicatorWidget(
            onRefresh: () async => await viewModel.refresh(),
            child: getViewForIndex(viewModel.currentIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: viewModel.currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: viewModel.setIndex,
        items: navs
            .map((nav) => BottomNavigationBarItem(
                icon: BuffySvgs.icon(
                    path: nav.iconPath,
                    color: Theme.of(context).colorScheme.onBackground),
                activeIcon: BuffySvgs.icon(
                    path: nav.activeIconPath,
                    color: Theme.of(context).colorScheme.onBackground),
                label: nav.label))
            .toList(),
      ),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const CategoryView();
      case 2:
        return const FavouriteView();
      default:
        return const HomeView();
    }
  }

  @override
  NavigationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      locator<NavigationViewModel>();
}

final List<BuffyNav> navs = [
  const BuffyNav(
      iconPath: Svgs.home, label: 'Home', activeIconPath: Svgs.homeFilled),
  const BuffyNav(
      iconPath: Svgs.category,
      label: 'Category',
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
