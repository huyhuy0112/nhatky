import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette — warm off-white & deep charcoal
  static const Color background = Color(0xFFF7F6F3);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFFEFEDE8);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textPrimaryDark = Color(0xFFF0EFE9);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFFAAAAAA);
  static const Color textTertiaryDark = Color(0xFF616161);

  // Accent — single warm accent
  static const Color accent = Color(0xFFE8612C);
  static const Color accentLight = Color(0xFFFAEDE7);
  static const Color accentDark = Color(0xFFFF7043);

  // Priority colors
  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFFB8C00);
  static const Color priorityLow = Color(0xFF43A047);
  static const Color priorityNone = Color(0xFFBDBDBD);

  // Status
  static const Color completed = Color(0xFF43A047);
  static const Color overdue = Color(0xFFE53935);
  static const Color upcoming = Color(0xFFFB8C00);

  // Border
  static const Color border = Color(0xFFE8E6E0);
  static const Color borderDark = Color(0xFF333333);

  // Category colors (soft pastels for minimalist look)
  static const List<Color> categoryColors = [
    Color(0xFFE8612C), // orange
    Color(0xFF5C6BC0), // indigo
    Color(0xFF26A69A), // teal
    Color(0xFFEC407A), // pink
    Color(0xFF8D6E63), // brown
    Color(0xFF66BB6A), // green
    Color(0xFF5C85D6), // blue
    Color(0xFFAB47BC), // purple
  ];
}
