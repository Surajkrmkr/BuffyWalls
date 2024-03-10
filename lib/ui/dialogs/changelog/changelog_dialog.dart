import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../common/common_export.dart';
import 'changelog_dialog_model.dart';

class ChangelogDialog extends StackedView<ChangelogDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ChangelogDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChangelogDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(left: 25, right: 10, top: 15, bottom: 5),
      title: Row(
        children: [
          Text(AppStrings.changelogText,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          const CloseButton()
        ],
      ),
      content: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Wrap(
              direction: Axis.vertical,
              spacing: 2,
              children: (viewModel.data as List<String>)
                  .map((log) =>
                      Text(log, style: Theme.of(context).textTheme.bodyMedium!))
                  .toList()),
      actions: [
        FilledButton(
            onPressed: viewModel.onGotItTapped, child: const Text("Got it"))
      ],
    );
  }

  @override
  ChangelogDialogModel viewModelBuilder(BuildContext context) =>
      ChangelogDialogModel();
}
