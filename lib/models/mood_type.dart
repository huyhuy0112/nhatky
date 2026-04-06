import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

enum MoodType {
  joyful(
    label: 'Vui vẻ',
    emoji: '😊',
    color: Color(0xFFFFE8A3),
    accent: Color(0xFFEF9A00),
    icon: Icons.sentiment_very_satisfied_rounded,
  ),
  calm(
    label: 'Bình yên',
    emoji: '😌',
    color: Color(0xFFC7F0E3),
    accent: Color(0xFF189C74),
    icon: Icons.self_improvement_rounded,
  ),
  focused(
    label: 'Tập trung',
    emoji: '🧠',
    color: Color(0xFFD7DBFF),
    accent: AppTheme.primary,
    icon: Icons.psychology_alt_rounded,
  ),
  tired(
    label: 'Mệt mỏi',
    emoji: '😮‍💨',
    color: Color(0xFFFFD9C2),
    accent: Color(0xFFEF6C35),
    icon: Icons.nightlight_round,
  ),
  sad(
    label: 'Trầm lắng',
    emoji: '🥲',
    color: Color(0xFFD6E7FF),
    accent: Color(0xFF3478F6),
    icon: Icons.cloud_rounded,
  );

  const MoodType({
    required this.label,
    required this.emoji,
    required this.color,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String emoji;
  final Color color;
  final Color accent;
  final IconData icon;
}
