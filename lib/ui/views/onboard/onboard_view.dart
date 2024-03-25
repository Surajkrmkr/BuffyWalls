import 'package:flutter/material.dart';

import '../../../app/app.package.export.dart';
import '../../../services/service_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'onboard_viewmodel.dart';

class OnboardView extends StackedView<OnboardViewModel> {
  const OnboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IgnorePointer(
            child: OverflowBox(
              maxWidth: screenWidth(context) + 200,
              maxHeight: screenHeight(context) + 200,
              child: BuffySkeleton(
                  enabled: viewModel.isBusy,
                  effect: pulseEffect(context),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            4,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: OnBoardList(
                                      isReversed: index.isEven,
                                      onBoardBanners: viewModel.isBusy
                                          ? []
                                          : viewModel
                                              .onBoardCollections[index]),
                                )),
                      ])),
            ),
          ),
          Container(
            height: screenHeight(context) * 0.7,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.background.withOpacity(0.2),
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            width: screenWidth(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      BuffyService.isPro
                          ? AppStrings.buffyWallsProTitle
                          : AppStrings.buffyWallsTitle,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                  verticalSpaceMedium,
                  Text(AppStrings.onBoardMsg,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold)),
                  verticalSpaceMedium,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                    onPressed: viewModel.onEnterTapped,
                    child: Text(AppStrings.enterMsg,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background)),
                  ),
                  verticalSpaceLarge,
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  OnboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnboardViewModel();

  @override
  void onViewModelReady(OnboardViewModel viewModel) => viewModel.getBanners();
}
