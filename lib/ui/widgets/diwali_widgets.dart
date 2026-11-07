import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Diwali {
  Diwali._();

  static final start = DateTime(2026, 11, 4);
  static final end = DateTime(2026, 11, 13);
  static const forceOn = bool.fromEnvironment('DIWALI_PREVIEW');

  static bool isActiveAt(DateTime date) =>
      !date.isBefore(start) && date.isBefore(end);

  static bool get active => forceOn || isActiveAt(DateTime.now());
}

class DiwaliLights extends StatelessWidget {
  final Widget child;
  final bool? enabled;

  const DiwaliLights({super.key, required this.child, this.enabled});

  @override
  Widget build(BuildContext context) => _DiwaliDecoration(
        enabled: enabled,
        child: child,
      );
}

class DiwaliTitle extends StatelessWidget {
  final Widget child;
  final bool? enabled;

  const DiwaliTitle({super.key, required this.child, this.enabled});

  @override
  Widget build(BuildContext context) => _DiwaliDecoration(
        enabled: enabled,
        diya: true,
        child: child,
      );
}

class _DiwaliDecoration extends StatefulWidget {
  final Widget child;
  final bool? enabled;
  final bool diya;

  const _DiwaliDecoration({
    required this.child,
    this.enabled,
    this.diya = false,
  });

  @override
  State<_DiwaliDecoration> createState() => _DiwaliDecorationState();
}

class _DiwaliDecorationState extends State<_DiwaliDecoration>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4800),
  );
  Timer? _boundaryTimer;
  bool get _active => widget.enabled ?? Diwali.active;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _DiwaliDecoration oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(_syncAnimation);
    } else {
      _animation.stop();
    }
  }

  void _syncAnimation() {
    if (_active && !MediaQuery.disableAnimationsOf(context)) {
      if (!_animation.isAnimating) _animation.repeat();
    } else {
      _animation.stop();
    }
    _boundaryTimer?.cancel();
    if (widget.enabled != null || Diwali.forceOn) return;
    final now = DateTime.now();
    final boundary = now.isBefore(Diwali.start) ? Diwali.start : Diwali.end;
    if (now.isBefore(boundary)) {
      _boundaryTimer = Timer(boundary.difference(now), () {
        if (mounted) setState(_syncAnimation);
      });
    }
  }

  @override
  void dispose() {
    _boundaryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return widget.child;
    final decoration = IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _DiwaliPainter(_animation, diya: widget.diya),
          ),
        ),
      ),
    );
    if (widget.diya) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: widget.child),
          const SizedBox(width: 8),
          SizedBox(width: 26, height: 26, child: decoration),
        ],
      );
    }
    return Stack(
      children: [
        widget.child,
        Positioned.fill(child: decoration),
      ],
    );
  }
}

class _DiwaliPainter extends CustomPainter {
  final Animation<double> animation;
  final bool diya;

  _DiwaliPainter(this.animation, {required this.diya})
      : super(repaint: animation);

  static const colors = [
    Color(0xFFFF9514),
    Color(0xFFFF3D71),
    Color(0xFFFFD60A),
    Color(0xFF3DDC84),
    Color(0xFF46BEFF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    if (diya) {
      _paintDiya(canvas, size);
      return;
    }
    final wire = Paint()
      ..color = const Color(0xAA4A4A52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    for (var strand = 0; strand < 2; strand++) {
      final baseline = size.height * (strand == 0 ? 0.06 : 0.55);
      final sag = size.height * 0.12;
      canvas.drawPath(
        Path()
          ..moveTo(0, baseline)
          ..quadraticBezierTo(
              size.width / 2, baseline + sag * 2, size.width, baseline),
        wire,
      );
      final count = (size.width / 19).round().clamp(3, 24);
      for (var bulb = 0; bulb < count; bulb++) {
        final position = (bulb + 0.5) / count;
        final center = Offset(size.width * position,
            baseline + 4 * sag * position * (1 - position) + 3);
        final brightness = 0.35 +
            0.65 *
                (0.5 +
                    0.5 *
                        math.sin(2 *
                            math.pi *
                            (animation.value * (1 + bulb % 3) +
                                position +
                                strand)));
        final color = colors[(bulb + strand * 2) % colors.length];
        canvas.drawCircle(
          center,
          4,
          Paint()
            ..color = color.withValues(alpha: brightness * 0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
        canvas.drawOval(
          Rect.fromCenter(center: center, width: 3, height: 4),
          Paint()..color = color.withValues(alpha: brightness),
        );
      }
    }
  }

  void _paintDiya(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    final flicker = math.sin(animation.value * math.pi * 8);
    final tip = 0.19 + flicker * 0.025;
    canvas.drawCircle(
      const Offset(0.5, 0.4),
      0.24,
      Paint()
        ..color = const Color(0x66FFA726)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.12),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0.5, tip)
        ..cubicTo(0.83, 0.5, 0.63, 0.62, 0.5, 0.62)
        ..cubicTo(0.3, 0.62, 0.28, 0.48, 0.5, tip),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE066), Color(0xFFFF8A00)],
        ).createShader(const Rect.fromLTWH(0.3, 0.2, 0.4, 0.42)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0.06, 0.64)
        ..quadraticBezierTo(0.5, 0.72, 0.94, 0.64)
        ..quadraticBezierTo(0.84, 0.95, 0.5, 0.95)
        ..quadraticBezierTo(0.16, 0.95, 0.06, 0.64),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF2A83B), Color(0xFFB8561A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(0, 0.64, 1, 0.31)),
    );
    canvas.drawLine(
      const Offset(0.12, 0.66),
      const Offset(0.88, 0.66),
      Paint()
        ..color = const Color(0xFFFFD98A)
        ..strokeWidth = 0.035
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiwaliPainter oldDelegate) =>
      oldDelegate.diya != diya || oldDelegate.animation != animation;
}
