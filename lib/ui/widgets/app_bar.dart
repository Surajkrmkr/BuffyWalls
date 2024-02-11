import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'widget_export.dart';

class BuffyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> categories;
  final bool showBackBtn;
  final bool showVersion;
  final bool showCloseBtn;
  const BuffyAppBar({
    super.key,
    required this.title,
    this.categories = const [],
    this.showBackBtn = false,
    this.showVersion = false,
    this.showCloseBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      leading: showVersion
          ? versionUI(context)
          : showBackBtn
              ? backIcon(context)
              : settingsIcon(context),
      actions: [showCloseBtn ? closeIcon(context) : searchIcon(context)],
      bottom: categories.isEmpty
          ? null
          : TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: categories
                  .map((category) => Tab(
                        child: Text(category),
                      ))
                  .toList()),
    );
  }

  Widget versionUI(context) => ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: Text(
              "v${viewModel.currentVersion}",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      });

  Widget backIcon(context) => IconButton(
      onPressed: () => Navigator.pop(context),
      iconSize: 34,
      icon: Icon(Icons.navigate_before_rounded,
          color: Theme.of(context).colorScheme.onBackground));

  Widget closeIcon(context) => Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: Theme.of(context).colorScheme.onBackground)),
      );

  Widget searchIcon(context) => IconButton(
      onPressed: () {},
      icon: BuffySvgs.icon(
          path: Svgs.search,
          color: Theme.of(context).colorScheme.onBackground));

  Widget settingsIcon(context) => IconButton(
      onPressed: () =>
          locator<NavigationService>().navigateToView(const SettingsView()),
      icon: BuffySvgs.icon(
          path: Svgs.settings,
          color: Theme.of(context).colorScheme.onBackground));

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
