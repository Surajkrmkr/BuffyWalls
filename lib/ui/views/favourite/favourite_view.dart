import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'favourite_viewmodel.dart';

class FavouriteView extends StackedView<FavouriteViewModel> {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FavouriteViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  FavouriteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FavouriteViewModel();
}
