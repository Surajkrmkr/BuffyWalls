import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuffySkeleton extends StatelessWidget {
  final TextBoneBorderRadius? textBoneBorderRadius;
  final bool ignorePointers;
  final bool? ignoreContainers;
  final bool enabled;
  final PaintingEffect effect;
  final Widget child;

  const BuffySkeleton(
      {super.key,
      this.textBoneBorderRadius,
      this.ignorePointers = false,
      this.ignoreContainers,
      required this.enabled,
      required this.effect,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      textBoneBorderRadius: textBoneBorderRadius,
      ignorePointers: ignorePointers,
      ignoreContainers: ignoreContainers,
      enabled: enabled,
      effect: effect,
      child: child,
    );
  }
}

PulseEffect pulseEffect(context) => PulseEffect(
      to: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      from: Theme.of(context).colorScheme.primary.withOpacity(0.3),
    );
