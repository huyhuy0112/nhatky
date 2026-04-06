import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/task.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Priority? _priority;
  String _sort = 'deadline';

  static const _sortOptions = [
    ('deadline', 'Deadline', Icons.access_time_rounded),
    ('priority', 'Độ ưu tiên', Icons.flag_rounded),
    ('created', 'Mới nhất', Icons.fiber_new_rounded),
    ('name', 'Tên A–Z', Icons.sort_by_alpha_rounded),
  ];

  static const _priorityOptions = [
    (Priority.high, 'Cao', AppColors.priorityHigh),
    (Priority.medium, 'TB', AppColors.priorityMedium),
    (Priority.low, 'Thấp', AppColors.priorityLow),
  ];

  void _apply() {
    // TODO: dispatch FilterEvent to FilterBloc
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _priority = null;
      _sort = 'deadline';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            child: Row(
              children: [
                Text(AppStrings.filter,
                  style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Đặt lại'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Sort section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.sortBy.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: _sortOptions.map((opt) {
                    final (val, label, icon) = opt;
                    final isSelected = _sort == val;
                    return GestureDetector(
                      onTap: () => setState(() => _sort = val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentLight : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon,
                              size: 14,
                              color: isSelected ? AppColors.accent : AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(label,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Priority filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.taskPriority.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: _priorityOptions.map((opt) {
                    final (priority, label, color) = opt;
                    final isSelected = _priority == priority;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.sm),
                      child: GestureDetector(
                        onTap: () => setState(() =>
                            _priority = isSelected ? null : priority),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withOpacity(0.12) : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            border: Border.all(
                              color: isSelected ? color : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text(label,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: isSelected ? color : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Apply button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _apply,
                child: const Text('Áp dụng'),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}
