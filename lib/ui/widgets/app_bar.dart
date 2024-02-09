import 'package:flutter/material.dart';

import '../common/common_export.dart';
import 'widget_export.dart';

class BuffyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> categories;
  final bool showBackBtn;
  const BuffyAppBar(
      {super.key,
      required this.title,
      this.categories = const [],
      this.showBackBtn = false});

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
      leading: showBackBtn ? const BackButton() : settingsIcon(context),
      actions: [searchIcon(context)],
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

  Widget searchIcon(context) => IconButton(
      onPressed: () {},
      icon: BuffySvgs.icon(
          path: Svgs.search,
          color: Theme.of(context).colorScheme.onBackground));

  Widget settingsIcon(context) => IconButton(
      onPressed: () {},
      icon: BuffySvgs.icon(
          path: Svgs.settings,
          color: Theme.of(context).colorScheme.onBackground));

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
