import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'color_detail_viewmodel.dart';

/// Dedicated Color landing page — Trending -> Newest -> Similar Colors ->
/// Explore. Colors are treated as mini editorial collections rather than
/// just an in-place Home filter.
class ColorDetailView extends StackedView<ColorDetailViewModel> {
  final Color color;
  final String colorName;
  const ColorDetailView({Key? key, required this.color, required this.colorName})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ColorDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BuffyAppBar(title: colorName, showBackBtn: true),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "$colorName Wallpapers",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SectionHeader(title: "🔥 Trending"),
                  WallpaperCarousel(walls: viewModel.trending),
                  const SectionHeader(title: "🆕 Newest"),
                  WallpaperCarousel(walls: viewModel.latest),
                  if (viewModel.similarColors.isNotEmpty) ...[
                    const SectionHeader(title: "🌈 Similar Colors"),
                    RelatedChipsRow(
                      labels: viewModel.similarColors,
                      colorFor: (label) => label.toLowerCase().toColor(),
                      onTap: (name) {
                        final newColor = name.toLowerCase().toColor();
                        AnalyticsService.instance.logColorFilterSelected(
                            '0x${newColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ColorDetailView(color: newColor, colorName: name),
                          ),
                        );
                      },
                    ),
                  ],
                  SectionHeader(title: "🖼 Explore", count: viewModel.walls.length),
                  WallpaperGridSection(
                    walls: viewModel.walls,
                    emptySubtitle: "Try another color or explore trending wallpapers",
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ColorDetailViewModel viewModelBuilder(BuildContext context) => ColorDetailViewModel();

  @override
  void onViewModelReady(ColorDetailViewModel viewModel) {
    viewModel.init(color, colorName);
  }
}
