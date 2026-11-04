import 'package:flutter/material.dart';

import '../../../app/app.export.dart';
import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';
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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final version = locator<HomeViewModel>().currentVersion;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: onSurface),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.settingsText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Reveal(child: _ProCard(viewModel: viewModel)),
            _Group(
              label: 'Personalise',
              tiles: settingsTopTiles(viewModel),
              delay: 60,
            ),
            _Group(
              label: 'Support',
              tiles: settingsBottomTiles(viewModel),
              delay: 120,
            ),
            _Group(
              label: 'About',
              tiles: settingsLowerBottomTiles(viewModel),
              delay: 180,
            ),
            Reveal(
              delay: const Duration(milliseconds: 240),
              child: _Community(tiles: settingsSocialTiles(viewModel)),
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                'BuffyWalls  ·  v$version',
                style: TextStyle(
                  fontSize: 12.5,
                  letterSpacing: 0.3,
                  color: onSurface.withOpacity(0.38),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Made by Team Shadow',
                style: TextStyle(
                  fontSize: 12,
                  color: onSurface.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(SettingsViewModel viewModel) =>
      viewModel.logSettingsScreen();

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}

class _ProCard extends StatelessWidget {
  final SettingsViewModel viewModel;
  const _ProCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isPro = BuffyService.isPro;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Pressable(
        scale: 0.985,
        onTap: viewModel.onBannerTapped,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 20, 18, 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: premiumGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPro ? 'YOU ARE PRO' : 'BUFFYWALLS PRO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: onGold.withOpacity(0.65),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isPro
                          ? 'Thank you for\nsupporting us'
                          : 'No ads. Every\nwallpaper unlocked.',
                      style: const TextStyle(
                        fontSize: 21,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: onGold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: onGold,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isPro ? 'More apps' : 'Get Pro',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: gold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String label;
  final List<SettingsTile> tiles;
  final int delay;
  const _Group({required this.label, required this.tiles, required this.delay});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Reveal(
      delay: Duration(milliseconds: delay),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: onSurface.withOpacity(0.42),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: dark ? surfaceDark : surfaceLight,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: onSurface.withOpacity(0.07)),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    _Row(tile: tiles[i]),
                    if (i != tiles.length - 1)
                      Divider(
                        height: 1,
                        indent: 64,
                        color: onSurface.withOpacity(0.07),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final SettingsTile tile;
  const _Row({required this.tile});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => tile.onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: onSurface.withOpacity(0.07),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(tile.iconData ?? Icons.circle_outlined,
                  size: 19, color: onSurface.withOpacity(0.85)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tile.title,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tile.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.5, color: onSurface.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20, color: onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}

class _Community extends StatelessWidget {
  final List<SettingsTile> tiles;
  const _Community({required this.tiles});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'COMMUNITY',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: onSurface.withOpacity(0.42),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i != 0) const SizedBox(width: 10),
                Expanded(
                  child: Pressable(
                    scale: 0.95,
                    onTap: () => tiles[i].onTap(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: dark ? surfaceDark : surfaceLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: onSurface.withOpacity(0.07)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: BuffySvgs.icon(
                              path: tiles[i].icon!,
                              color: onSurface.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tiles[i].title,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: onSurface.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
