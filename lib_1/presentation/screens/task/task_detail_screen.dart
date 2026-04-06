import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/deadline_chip.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              // TODO: navigate to TaskFormScreen(task: task)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status Badge ──────────────────────────────────
            if (task.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.completed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                      size: 14, color: AppColors.completed),
                    const SizedBox(width: 4),
                    Text('Đã hoàn thành',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.completed,
                      )),
                  ],
                ),
              )
            else if (task.isOverdue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.overdue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                      size: 14, color: AppColors.overdue),
                    const SizedBox(width: 4),
                    Text('Quá hạn',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.overdue,
                      )),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // ── Title ─────────────────────────────────────────
            Text(
              task.title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? AppColors.textTertiary : null,
              ),
            ),

            const SizedBox(height: 16),

            // ── Meta Row ──────────────────────────────────────
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                PriorityBadge(priority: task.priority),
                if (task.deadline != null) DeadlineChip(deadline: task.deadline!),
              ],
            ),

            if (task.note != null && task.note!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),
              Text(
                'Ghi chú',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.note!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],

            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: task.tags.map((tag) => _TagChip(label: tag)).toList(),
              ),
            ],

            if (task.reminderAt != null) ...[
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),
              _InfoRow(
                icon: Icons.notifications_active_rounded,
                label: 'Nhắc lúc',
                value: _formatDate(task.reminderAt!),
                color: AppColors.accent,
              ),
            ],

            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'Tạo lúc',
              value: _formatDate(task.createdAt),
              color: AppColors.textTertiary,
            ),

            const SizedBox(height: 40),

            // ── Complete Toggle ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted
                      ? AppColors.surfaceVariant
                      : AppColors.accent,
                  foregroundColor: task.isCompleted
                      ? AppColors.textSecondary
                      : Colors.white,
                ),
                icon: Icon(
                  task.isCompleted
                      ? Icons.replay_rounded
                      : Icons.check_rounded,
                  size: AppSizes.iconMd,
                ),
                label: Text(
                  task.isCompleted
                      ? AppStrings.markIncomplete
                      : AppStrings.markComplete,
                ),
                onPressed: () {
                  context.read<TaskBloc>().add(
                    ToggleTaskCompleteEvent(
                      task.id,
                      isCompleted: !task.isCompleted,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconSm, color: color),
        const SizedBox(width: AppSizes.sm),
        Text('$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Text(value,
          style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        '#$label',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
