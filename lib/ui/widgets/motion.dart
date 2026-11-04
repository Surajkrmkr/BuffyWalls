import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and lifts [child] into place the first time it scrolls into view.
/// [delay] staggers siblings that appear together (e.g. a row of cards).
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double offset;
  final Axis axis;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 28,
    this.axis = Axis.vertical,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
  final Key _visKey = UniqueKey();
  bool _started = false;

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08) _start();
      },
      child: AnimatedBuilder(
        animation: _t,
        child: widget.child,
        builder: (context, child) {
          final v = _t.value;
          final shift = (1 - v) * widget.offset;
          return Opacity(
            opacity: v,
            child: Transform.translate(
              offset: widget.axis == Axis.vertical
                  ? Offset(0, shift)
                  : Offset(shift, 0),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Tactile press feedback: the child eases down slightly while held.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final HitTestBehavior behavior;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Drives one shared shimmer sweep for every [SkelBox] beneath it, so all
/// the loading shapes on a screen pulse in sync.
class ShimmerHost extends StatefulWidget {
  final Widget child;
  const ShimmerHost({super.key, required this.child});

  @override
  State<ShimmerHost> createState() => _ShimmerHostState();
}

class _ShimmerHostState extends State<ShimmerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _ShimmerScope(animation: _c, child: widget.child);
}

class _ShimmerScope extends InheritedWidget {
  final Animation<double> animation;
  const _ShimmerScope({required this.animation, required super.child});

  static Animation<double>? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScope>()?.animation;

  @override
  bool updateShouldNotify(_ShimmerScope old) => animation != old.animation;
}

/// A placeholder block. Built from the same width/height/radius constants
/// as the real widget it stands in for, so layout never jumps on load.
class SkelBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const SkelBox({super.key, this.width, this.height, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? const Color(0xFF1C1C22) : const Color(0xFFE6E2D9);
    final hi = dark ? const Color(0xFF2B2B33) : const Color(0xFFF3F0E8);
    final anim = _ShimmerScope.maybeOf(context);

    Widget box(double t) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.6 + 3.2 * t, -0.3),
              end: Alignment(-0.6 + 3.2 * t, 0.3),
              colors: [base, hi, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );

    if (anim == null) return box(0.5);
    return AnimatedBuilder(
        animation: anim, builder: (_, __) => box(anim.value));
  }
}
