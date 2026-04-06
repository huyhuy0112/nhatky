import 'package:flutter/material.dart';

import '../../models/mood_type.dart';

class MoodChip extends StatelessWidget {
  const MoodChip({
    super.key,
    required this.mood,
    this.isSelected = false,
    this.onTap,
  });

  final MoodType mood;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? mood.accent : mood.color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mood.emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              mood.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : mood.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
