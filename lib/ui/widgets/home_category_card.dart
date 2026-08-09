import 'package:flutter/material.dart';
import '../common/category_theme.dart';

class HomeCategoryCard extends StatefulWidget {
  final String categoryName;
  final int count;
  final VoidCallback onTap;

  const HomeCategoryCard({
    super.key,
    required this.categoryName,
    required this.count,
    required this.onTap,
  });

  @override
  State<HomeCategoryCard> createState() => _HomeCategoryCardState();
}

class _HomeCategoryCardState extends State<HomeCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).push(
        CategoryTheme.createCategoryRoute(widget.categoryName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = CategoryTheme.getTheme(widget.categoryName);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final labelOpacity = _opacityAnimation.value;
        final glowVal = _glowAnimation.value;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _handleTap(),
            onTapCancel: () => _controller.reverse(),
            child: Container(
              width: 136,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.lerp(
                    Theme.of(context).dividerColor.withOpacity(0.08),
                    style.accentColor.withOpacity(0.4),
                    glowVal,
                  )!,
                  width: 1.5,
                ),
                boxShadow: [
                  if (glowVal > 0)
                    BoxShadow(
                      color: style.accentColor.withOpacity(0.25 * glowVal),
                      blurRadius: 12 * glowVal,
                      spreadRadius: 1 * glowVal,
                      offset: const Offset(0, 4),
                    ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vector icon container badge
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: style.accentColor.withOpacity(0.12),
                      border: Border.all(
                        color: style.accentColor.withOpacity(0.22),
                        width: 1.2,
                      ),
                      boxShadow: [
                        if (glowVal > 0)
                          BoxShadow(
                            color: style.accentColor.withOpacity(0.3 * glowVal),
                            blurRadius: 8 * glowVal,
                          ),
                      ],
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [style.accentColor, style.secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Icon(
                          style.icon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Category details & count
                  Opacity(
                    opacity: labelOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${widget.count} wallpapers',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
