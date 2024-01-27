import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import '../view_export.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: BuffyAppBar(title: AppStrings.buffyWallsTitle),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
