import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'model/settings_tile.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const BuffyAppBar(
          title: AppStrings.settingsText,
          showVersion: true,
          showCloseBtn: true,
        ),
        SliverToBoxAdapter(
          child: _bodyUI(viewModel, context),
        ),
      ],
    ));
  }

  Widget _bodyUI(SettingsViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: const Placeholder(),
        ),
        ...settingsTopTiles(viewModel)
            .map((tile) => _settingsTileUI(tile, context)),
        _dividerUI(),
        ...settingsBottomTiles(viewModel)
            .map((tile) => _settingsTileUI(tile, context)),
        _dividerUI(),
        ...settingsLowerBottomTiles(viewModel)
            .map((tile) => _settingsTileUI(tile, context)),
        _dividerUI(),
        ...settingsSocialTiles(viewModel)
            .map((tile) => _settingsTileUI(tile, context))
      ],
    );
  }

  Divider _dividerUI() {
    return const Divider(
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  ListTile _settingsTileUI(SettingsTile tile, BuildContext context) {
    return ListTile(
      title: Text(tile.title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(tile.description),
      leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: BuffySvgs.iconWithoutColor(path: tile.icon)),
      onTap: tile.onTap,
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}