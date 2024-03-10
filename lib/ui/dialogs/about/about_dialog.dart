import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import 'about_dialog_model.dart';

class AboutDialog extends StackedView<AboutDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AboutDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AboutDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 25, right: 10, top: 15),
      title: const Row(
        children: [Spacer(), CloseButton()],
      ),
      content: Wrap(children: [
        Center(
          child: Column(
            children: [
              Image.asset(Images.transparentCropIcon, width: 80),
              verticalSpaceMedium,
              Text(
                  BuffyService.isPro
                      ? AppStrings.buffyWallsProTitle
                      : AppStrings.buffyWallsTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(viewModel.currentVersion,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              verticalSpaceMedium,
              Text(AppStrings.copyright,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(AppStrings.rights,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ]),
      actions: [
        FilledButton(
            onPressed: viewModel.onRateUsTapped,
            child: const Text(AppStrings.rateText)),
        OutlinedButton(
            onPressed: viewModel.onGotItTapped,
            child: const Text(AppStrings.gotIt))
      ],
    );
  }

  @override
  AboutDialogModel viewModelBuilder(BuildContext context) => AboutDialogModel();
}
