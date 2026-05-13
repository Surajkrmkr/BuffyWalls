import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buffywalls/app/app.export.dart';
import 'package:flutter/material.dart';

import '../../app/app.package.export.dart';
import '../../services/service_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';
import 'widget_export.dart';

class BuffyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> categories;
  final bool showBackBtn;
  final bool showVersion;
  final bool showCloseBtn;
  final bool showAnimatedText;
  final bool showProIcon;
  final List<String> titles;
  const BuffyAppBar({
    super.key,
    required this.title,
    this.categories = const [],
    this.showBackBtn = false,
    this.showVersion = false,
    this.showCloseBtn = false,
    this.showAnimatedText = false,
    this.showProIcon = false,
    this.titles = const [AppStrings.buffyWallsTitle],
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      centerTitle: true,
      title: showAnimatedText
          ? animatedText(context)
          : Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
      leading: showVersion
          ? versionUI(context)
          : showBackBtn
              ? backIcon(context)
              : settingsIcon(context),
      actions: [
        showProIcon && !BuffyService.isPro
            ? proBadge(context)
            : const SizedBox(),
        showCloseBtn ? closeIcon(context) : searchIcon(context)
      ],
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
      onPressed: () => locator<NavigationService>().navigateToSearchView(),
      icon: BuffySvgs.icon(
          path: Svgs.search,
          color: Theme.of(context).colorScheme.onBackground));

  Widget settingsIcon(context) => IconButton(
      onPressed: () => locator<NavigationService>().navigateToSettingsView(),
      icon: BuffySvgs.icon(
          path: Svgs.settings,
          color: Theme.of(context).colorScheme.onBackground));

  Widget animatedText(context) => AnimatedTextKit(
      totalRepeatCount: 3,
      animatedTexts: titles
          .map((title) => TypewriterAnimatedText(
                title,
                textStyle: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w700),
                speed: const Duration(milliseconds: 100),
              ))
          .toList());

  Widget proBadge(context) => InkWell(
        onTap: () => locator<DialogService>().showCustomDialog(
          variant: DialogType.pro,
          barrierDismissible: false,
          data: {'hideWatchAd': true},
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(8)),
          child: Text('PRO',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.background)),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
