import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class DeadlinePicker extends StatelessWidget {
  final DateTime? deadline;
  final ValueChanged<DateTime?> onChanged;

  const DeadlinePicker({super.key, required this.deadline, required this.onChanged});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $h:$m';
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: deadline ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline ?? now),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (pickedTime == null) return;

    onChanged(DateTime(
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    ));
  }

  // Quick select shortcuts
  static final _shortcuts = [
    ('Hôm nay', Duration.zero),
    ('Ngày mai', const Duration(days: 1)),
    ('Tuần tới', const Duration(days: 7)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick shortcuts
        Row(
          children: _shortcuts.map((shortcut) {
            final (label, offset) = shortcut;
            final target = DateTime.now().add(offset);
            final isSelected = deadline != null &&
                deadline!.year == target.year &&
                deadline!.month == target.month &&
                deadline!.day == target.day;
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: GestureDetector(
                onTap: () => onChanged(
                  DateTime(target.year, target.month, target.day, 9, 0),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentLight : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSizes.sm),

        // Custom date picker row
        GestureDetector(
          onTap: () => _pick(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg, vertical: AppSizes.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: AppSizes.iconMd,
                  color: deadline != null ? AppColors.accent : AppColors.textTertiary,
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    deadline != null ? _formatDate(deadline!) : 'Chọn ngày & giờ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: deadline != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
                if (deadline != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: const Icon(
                      Icons.close_rounded,
                      size: AppSizes.iconSm,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
