import 'package:flutter/material.dart';

import '../common/common_export.dart';
import 'widget_export.dart';

class BuffyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const BuffyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      leading: settingsIcon(context),
      actions: [searchIcon(context)],
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
