import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const RefreshIndicatorWidget(
      {super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      notificationPredicate: (notification) =>
          notification.metrics.axisDirection == AxisDirection.down,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      color: Theme.of(context).colorScheme.onBackground,
      edgeOffset: 60,
      child: child,
    );
  }
}
