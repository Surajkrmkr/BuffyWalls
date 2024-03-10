import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'image_viewmodel.dart';

class ImageView extends StackedView<ImageViewModel> {
  final PopularWall wall;
  const ImageView({Key? key, required this.wall}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ImageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        CacheImage(imageUrl: wall.imageUrl, fullView: true),
        Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: viewModel.toggleInfoUI,
                onLongPress: viewModel.toggleInfoUI)),
        _buildBackBtn(context),
        _buildInfoUI(context, viewModel),
      ],
    ));
  }

  Widget _colorsUI(ImageViewModel model, BuildContext context) {
    final List<Color> colors = model.isBusy
        ? List.generate(8, (index) => Colors.black38)
        : model.colorSwatches;
    return BuffySkeleton(
      enabled: model.isBusy,
      effect: pulseEffect(context),
      child: _colorsListViewUI(colors, onSelected: (color) {}),
    );
  }

  Widget _colorsListViewUI(List<Color> colors,
      {required Function(Color) onSelected}) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: colors
            .map((color) => ActionChip(
                label: const Text("          "),
                backgroundColor: color,
                onPressed: () => onSelected(color),
                shape: const RoundedRectangleBorder(
                    side: BorderSide(style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(15)))))
            .toList());
  }

  AnimatedOpacity _buildInfoUI(BuildContext context, ImageViewModel viewModel) {
    return AnimatedOpacity(
      opacity: viewModel.hideInfoUI ? 0 : 1,
      duration: Durations.short4,
      child: IgnorePointer(
        ignoring: viewModel.hideInfoUI,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              runSpacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(25)),
                  child: _buildWallContentUI(context, viewModel),
                ),
                _buildBottomActionUI(context, viewModel)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildBottomActionUI(BuildContext context, ImageViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.onBackground),
              onPressed: viewModel.toggleApplyWallUI,
              child: Text(
                viewModel.showApplyWallUI
                    ? AppStrings.seeInfoWallpaper
                    : AppStrings.applyWallpaper,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              )),
        ),
        horizontalSpaceSmall,
        IconButton.filled(
          padding: const EdgeInsets.all(15),
          style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background),
          color: Theme.of(context).colorScheme.onBackground,
          onPressed: () => viewModel.downloadWallpaper(
              wall.imageUrl, "${wall.name}_${wall.id}"),
          icon: Visibility(
            replacement: const SizedBox.square(
                dimension: 24,
                child: Center(child: CircularProgressIndicator())),
            visible: !viewModel.isWallDownloading,
            child: Icon(
              viewModel.isWallDownloaded ? Icons.check : Icons.download_rounded,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWallContentUI(BuildContext context, ImageViewModel viewModel) {
    return viewModel.showApplyWallUI
        ? Wrap(
            spacing: 10,
            runSpacing: 10,
            children: WallApplyAction.values
                .map((action) => FilledButton(
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: () =>
                        viewModel.applyWallpaper(action, wall.imageUrl),
                    child: Center(
                        child: Text(
                      action.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold, color: backgroundLight),
                    ))))
                .toList())
        : Wrap(children: [
            _buildWallInfoUI(context, viewModel),
            const Divider(),
            Text(
              "Colors",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpaceMedium,
            _colorsUI(viewModel, context)
          ]);
  }

  Row _buildWallInfoUI(BuildContext context, ImageViewModel viewModel) {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wall.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              wall.designer,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(),
            ),
            Text(
              viewModel.imageResolution,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(),
            ),
            Text(
              viewModel.imageSize,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(),
            )
          ],
        ),
      ),
      IconButton(
        icon: const Icon(Icons.favorite),
        onPressed: () {},
      )
    ]);
  }

  SafeArea _buildBackBtn(BuildContext context) {
    return SafeArea(
        child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                iconSize: 34,
                icon: const Icon(Icons.navigate_before_rounded,
                    color: backgroundLight))));
  }

  @override
  ImageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ImageViewModel();

  @override
  void onViewModelReady(ImageViewModel viewModel) {
    viewModel.checkIfWallDownloaded("${wall.name}_${wall.id}");
    viewModel.getColorPalette(wall.compressUrl);
    viewModel.getImgDetails(wall.imageUrl);
  }
}
