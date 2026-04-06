import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class DeadlineChip extends StatelessWidget {
  final DateTime deadline;
  final bool compact;

  const DeadlineChip({super.key, required this.deadline, this.compact = false});

  bool get _isOverdue => deadline.isBefore(DateTime.now());
  bool get _isToday {
    final now = DateTime.now();
    return deadline.year == now.year &&
        deadline.month == now.month &&
        deadline.day == now.day;
  }
  bool get _isTomorrow {
    final tom = DateTime.now().add(const Duration(days: 1));
    return deadline.year == tom.year &&
        deadline.month == tom.month &&
        deadline.day == tom.day;
  }

  Color _bg() {
    if (_isOverdue) return AppColors.overdue.withOpacity(0.12);
    if (_isToday) return AppColors.accent.withOpacity(0.10);
    return AppColors.surfaceVariant;
  }

  Color _fg() {
    if (_isOverdue) return AppColors.overdue;
    if (_isToday) return AppColors.accent;
    return AppColors.textTertiary;
  }

  String _label() {
    if (_isOverdue) return 'Quá hạn';
    if (_isToday) return 'Hôm nay';
    if (_isTomorrow) return 'Ngày mai';
    final diff = deadline.difference(DateTime.now()).inDays;
    if (diff < 7) return '${diff}d nữa';
    return '${deadline.day}/${deadline.month}';
  }

  @override
  Widget build(BuildContext context) {
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
          Icon(
            _isOverdue
                ? Icons.warning_amber_rounded
                : Icons.access_time_rounded,
            size: 11,
            color: _fg(),
          ),
          const SizedBox(width: 3),
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
