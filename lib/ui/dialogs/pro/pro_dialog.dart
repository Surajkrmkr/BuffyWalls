import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/common_export.dart';
import 'pro_dialog_model.dart';

class ProDialog extends StackedView<ProDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ProDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(left: 25, right: 10, top: 15, bottom: 5),
      title: Row(
        children: [
          Text(AppStrings.buyProText,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          const CloseButton()
        ],
      ),
      content: Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Image.asset(Images.transparentCropIcon, width: 80),
          verticalSpaceMedium,
          Text(AppStrings.buffyWallsProTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500)),
          verticalSpaceMedium,
          Text(AppStrings.proDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!),
        ],
      ),
      actions: [
        FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(45)),
            onPressed: viewModel.onGetProTapped,
            child: Text("Get Pro",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background)))
      ],
    );
  }

  @override
  ProDialogModel viewModelBuilder(BuildContext context) => ProDialogModel();
}
