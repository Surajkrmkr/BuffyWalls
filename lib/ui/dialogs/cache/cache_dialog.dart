import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/common_export.dart';
import 'cache_dialog_model.dart';

class CacheDialog extends StackedView<CacheDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const CacheDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CacheDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding:
          const EdgeInsets.only(left: 25, right: 10, top: 15, bottom: 5),
      title: Row(
        children: [
          Text(AppStrings.cache,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          const CloseButton()
        ],
      ),
      content: Text(AppStrings.cacheDesc,
          style: Theme.of(context).textTheme.bodyLarge!),
      actions: [
        TextButton(onPressed: viewModel.onCancle, child: const Text("Cancle")),
        ElevatedButton(onPressed: viewModel.clearCache, child: const Text("Ok"))
      ],
    );
  }

  @override
  CacheDialogModel viewModelBuilder(BuildContext context) => CacheDialogModel();
}
