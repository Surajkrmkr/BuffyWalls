import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/common_export.dart';
import 'theme_dialog_model.dart';

class ThemeDialog extends StackedView<ThemeDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ThemeDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ThemeDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 20, right: 5),
            child: Row(
              children: [
                Text(AppStrings.themeMode,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                const CloseButton()
              ],
            ),
          ),
          ...ThemeMode.values
              .map((mode) => RadioListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  value: mode,
                  title: Text(mode.name.capitalize(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  groupValue: viewModel.themeMode,
                  onChanged: viewModel.setThemeMode))
              .toList()
        ],
      ),
    ));
  }

  @override
  ThemeDialogModel viewModelBuilder(BuildContext context) =>
      ThemeDialogModel(context);

  @override
  void onViewModelReady(ThemeDialogModel viewModel) => viewModel.getThemeMode();
}
