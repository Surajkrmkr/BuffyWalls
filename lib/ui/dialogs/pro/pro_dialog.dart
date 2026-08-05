import 'dart:ui';
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF02081C).withOpacity(0.85)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => completer(DialogResponse(confirmed: false)),
                    icon: const Icon(Icons.close_rounded),
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
              Image.asset(Images.transparentCropIcon, width: 90),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  AppStrings.buffyWallsProTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.proDesc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 28),
              if (request.data?['hideWatchAd'] != true) ...[
                GestureDetector(
                  onTap: () => viewModel.onWatchAdTapped(
                    () => completer(DialogResponse(confirmed: true)),
                    wallId: request.data?['wallId'] as int?,
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Watch Ad to Unlock",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              GestureDetector(
                onTap: viewModel.onGetProTapped,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0BB0E3), Color(0xFF3603C6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3603C6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Get Pro",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProDialogModel viewModelBuilder(BuildContext context) => ProDialogModel();
}
