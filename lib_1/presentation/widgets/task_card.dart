import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import 'priority_badge.dart';
import 'deadline_chip.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  Color _priorityAccent() {
    switch (task.priority) {
      case Priority.high: return AppColors.priorityHigh;
      case Priority.medium: return AppColors.priorityMedium;
      case Priority.low: return AppColors.priorityLow;
      case Priority.none: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.xl),
        decoration: BoxDecoration(
          color: AppColors.priorityHigh.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.priorityHigh,
          size: AppSizes.iconLg,
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            title: const Text('Xoá task'),
            content: Text(
              'Bạn chắc chắn muốn xoá "${task.title}"?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xoá', style: TextStyle(color: AppColors.priorityHigh)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
      },
      child: GestureDetector(
        onTap: onTap ?? () {
          // TODO: navigate to TaskDetailScreen(task: task)
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: task.isCompleted
                ? AppColors.surface.withOpacity(0.6)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: task.isOverdue
                  ? AppColors.overdue.withOpacity(0.3)
                  : AppColors.border,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // ── Priority stripe ──────────────────────────
                if (task.priority != Priority.none)
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: _priorityAccent(),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppSizes.radiusLg),
                      ),
                    ),
                  ),

                // ── Checkbox ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: _AnimatedCheckbox(
                    checked: task.isCompleted,
                    onChanged: (val) {
                      context.read<TaskBloc>().add(
                        ToggleTaskCompleteEvent(task.id, isCompleted: val),
                      );
                    },
                  ),
                ),

                // ── Content ───────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? AppColors.textTertiary : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Note preview
                        if (task.note != null && task.note!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            task.note!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        // Meta chips
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: AppSizes.xs,
                          runSpacing: AppSizes.xs,
                          children: [
                            if (task.deadline != null)
                              DeadlineChip(deadline: task.deadline!),
                            if (task.priority != Priority.none)
                              PriorityBadge(priority: task.priority, compact: true),
                            ...task.tags.take(2).map((tag) => _TagChip(label: tag)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _AnimatedCheckbox extends StatefulWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _AnimatedCheckbox({required this.checked, required this.onChanged});

  @override
  State<_AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<_AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween<double>(begin: 1, end: 0.85).chain(CurveTween(curve: Curves.easeInOut)).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _tap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onChanged(!widget.checked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: widget.checked ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.checked ? AppColors.accent : AppColors.border,
              width: 1.5,
            ),
          ),
          child: widget.checked
              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        '#$label',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
