import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/task.dart';

class PriorityBadge extends StatelessWidget {
  final Priority priority;
  final bool compact;

  const PriorityBadge({super.key, required this.priority, this.compact = false});

  Color _bg() {
    switch (priority) {
      case Priority.high: return AppColors.priorityHigh.withOpacity(0.12);
      case Priority.medium: return AppColors.priorityMedium.withOpacity(0.12);
      case Priority.low: return AppColors.priorityLow.withOpacity(0.12);
      case Priority.none: return AppColors.surfaceVariant;
    }
  }

  Color _fg() {
    switch (priority) {
      case Priority.high: return AppColors.priorityHigh;
      case Priority.medium: return AppColors.priorityMedium;
      case Priority.low: return AppColors.priorityLow;
      case Priority.none: return AppColors.textTertiary;
    }
  }

  String _label() {
    switch (priority) {
      case Priority.high: return AppStrings.priorityHigh;
      case Priority.medium: return AppStrings.priorityMedium;
      case Priority.low: return AppStrings.priorityLow;
      case Priority.none: return AppStrings.priorityNone;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (priority == Priority.none) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: _fg(), shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            _label(),
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: _fg(),
            ),
          ),
        ],
      ),
    );
  }
}
