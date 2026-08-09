import 'package:flutter/material.dart';
import '../views/category_detail/category_detail_view.dart';

class CategoryStyle {
  final IconData icon;
  final Color accentColor;
  final Color secondaryColor;

  const CategoryStyle({
    required this.icon,
    required this.accentColor,
    required this.secondaryColor,
  });
}

class CategoryTheme {
  static CategoryStyle getTheme(String categoryName) {
    final name = categoryName.trim().toLowerCase();

    if (name.contains('nature')) {
      return const CategoryStyle(
        icon: Icons.forest_rounded,
        accentColor: Color(0xFF10B981),
        secondaryColor: Color(0xFF059669),
      );
    }
    if (name.contains('amoled')) {
      return const CategoryStyle(
        icon: Icons.dark_mode_rounded,
        accentColor: Color(0xFFA855F7),
        secondaryColor: Color(0xFF6366F1),
      );
    }
    if (name.contains('hero') || name.contains('super')) {
      return const CategoryStyle(
        icon: Icons.shield_rounded,
        accentColor: Color(0xFFEF4444),
        secondaryColor: Color(0xFFF59E0B),
      );
    }
    if (name.contains('anime')) {
      return const CategoryStyle(
        icon: Icons.auto_awesome_rounded,
        accentColor: Color(0xFFEC4899),
        secondaryColor: Color(0xFFF43F5E),
      );
    }
    if (name.contains('car')) {
      return const CategoryStyle(
        icon: Icons.directions_car_rounded,
        accentColor: Color(0xFFF97316),
        secondaryColor: Color(0xFFEF4444),
      );
    }
    if (name.contains('bike') || name.contains('motor')) {
      return const CategoryStyle(
        icon: Icons.two_wheeler_rounded,
        accentColor: Color(0xFF06B6D4),
        secondaryColor: Color(0xFF3B82F6),
      );
    }
    if (name.contains('sport')) {
      return const CategoryStyle(
        icon: Icons.sports_soccer_rounded,
        accentColor: Color(0xFFEAB308),
        secondaryColor: Color(0xFFF59E0B),
      );
    }
    if (name.contains('space') || name.contains('galaxy')) {
      return const CategoryStyle(
        icon: Icons.travel_explore_rounded,
        accentColor: Color(0xFF818CF8),
        secondaryColor: Color(0xFFC084FC),
      );
    }
    if (name.contains('abstract')) {
      return const CategoryStyle(
        icon: Icons.interests_rounded,
        accentColor: Color(0xFF3B82F6),
        secondaryColor: Color(0xFF8B5CF6),
      );
    }
    if (name.contains('minimal')) {
      return const CategoryStyle(
        icon: Icons.crop_square_rounded,
        accentColor: Color(0xFF94A3B8),
        secondaryColor: Color(0xFF64748B),
      );
    }
    if (name.contains('architect') || name.contains('city') || name.contains('building')) {
      return const CategoryStyle(
        icon: Icons.location_city_rounded,
        accentColor: Color(0xFFD97706),
        secondaryColor: Color(0xFFB45309),
      );
    }
    if (name.contains('animal') || name.contains('pet')) {
      return const CategoryStyle(
        icon: Icons.pets_rounded,
        accentColor: Color(0xFF14B8A6),
        secondaryColor: Color(0xFF0D9488),
      );
    }
    if (name.contains('game') || name.contains('gaming')) {
      return const CategoryStyle(
        icon: Icons.sports_esports_rounded,
        accentColor: Color(0xFF8B5CF6),
        secondaryColor: Color(0xFFEC4899),
      );
    }
    if (name.contains('spirit') || name.contains('god') || name.contains('devotion')) {
      return const CategoryStyle(
        icon: Icons.self_improvement_rounded,
        accentColor: Color(0xFFF59E0B),
        secondaryColor: Color(0xFFD97706),
      );
    }
    if (name.contains('tech')) {
      return const CategoryStyle(
        icon: Icons.memory_rounded,
        accentColor: Color(0xFF0284C7),
        secondaryColor: Color(0xFF06B6D4),
      );
    }
    if (name.contains('neon') || name.contains('glow')) {
      return const CategoryStyle(
        icon: Icons.bolt_rounded,
        accentColor: Color(0xFFA3E635),
        secondaryColor: Color(0xFF22C55E),
      );
    }
    if (name.contains('fantas')) {
      return const CategoryStyle(
        icon: Icons.diamond_rounded,
        accentColor: Color(0xFFD946EF),
        secondaryColor: Color(0xFF8B5CF6),
      );
    }
    if (name.contains('dark')) {
      return const CategoryStyle(
        icon: Icons.bedtime_rounded,
        accentColor: Color(0xFF38BDF8),
        secondaryColor: Color(0xFF1E293B),
      );
    }
    if (name.contains('art')) {
      return const CategoryStyle(
        icon: Icons.palette_rounded,
        accentColor: Color(0xFFF43F5E),
        secondaryColor: Color(0xFFFB7185),
      );
    }
    if (name.contains('creat')) {
      return const CategoryStyle(
        icon: Icons.flare_rounded,
        accentColor: Color(0xFFC084FC),
        secondaryColor: Color(0xFFF472B6),
      );
    }

    // Default Fallback for any other category
    return const CategoryStyle(
      icon: Icons.explore_rounded,
      accentColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF8B5CF6),
    );
  }

  static Route createCategoryRoute(String category) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CategoryDetailView(category: category),
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
