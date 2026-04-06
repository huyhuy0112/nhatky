import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/priority_selector.dart';
import '../../widgets/deadline_picker.dart';
import '../../widgets/tag_input.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // null = create, non-null = edit
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _noteCtrl;

  Priority _priority = Priority.none;
  DateTime? _deadline;
  DateTime? _reminderAt;
  List<String> _tags = [];
  bool _isSaving = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleCtrl = TextEditingController(text: task?.title ?? '');
    _noteCtrl = TextEditingController(text: task?.note ?? '');
    _priority = task?.priority ?? Priority.none;
    _deadline = task?.deadline;
    _reminderAt = task?.reminderAt;
    _tags = List.from(task?.tags ?? []);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final now = DateTime.now();
    if (_isEditing) {
      final updated = widget.task!.copyWith(
        title: _titleCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        deadline: _deadline,
        reminderAt: _reminderAt,
        priority: _priority,
        tags: _tags,
        updatedAt: now,
      );
      context.read<TaskBloc>().add(UpdateTaskEvent(updated));
    } else {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        deadline: _deadline,
        reminderAt: _reminderAt,
        priority: _priority,
        tags: _tags,
        createdAt: now,
        updatedAt: now,
      );
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    }

    if (mounted) Navigator.of(context).pop();
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        title: Text(AppStrings.deleteTaskTitle,
          style: Theme.of(context).textTheme.headlineSmall),
        content: Text(AppStrings.deleteTaskConfirm,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(widget.task!.id));
              Navigator.of(context)..pop()..pop();
            },
            child: const Text(AppStrings.delete,
              style: TextStyle(color: AppColors.priorityHigh)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isEditing ? AppStrings.editTask : AppStrings.newTask),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.priorityHigh),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding, 8, AppSizes.screenPadding, 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ─────────────────────────────────────────
              AppTextField(
                controller: _titleCtrl,
                label: AppStrings.taskTitle,
                hint: 'Nhập tiêu đề task...',
                maxLines: 2,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // ── Note ──────────────────────────────────────────
              AppTextField(
                controller: _noteCtrl,
                label: AppStrings.taskNote,
                hint: 'Thêm ghi chú...',
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSizes.xxl),

              // ── Priority ──────────────────────────────────────
              _FieldLabel(AppStrings.taskPriority),
              const SizedBox(height: AppSizes.sm),
              PrioritySelector(
                selected: _priority,
                onChanged: (p) => setState(() => _priority = p),
              ),
              const SizedBox(height: AppSizes.xxl),

              // ── Deadline ──────────────────────────────────────
              _FieldLabel(AppStrings.taskDeadline),
              const SizedBox(height: AppSizes.sm),
              DeadlinePicker(
                deadline: _deadline,
                onChanged: (dt) => setState(() => _deadline = dt),
              ),
              const SizedBox(height: AppSizes.xxl),

              // ── Reminder ──────────────────────────────────────
              _FieldLabel(AppStrings.taskReminder),
              const SizedBox(height: AppSizes.sm),
              _ReminderRow(
                reminderAt: _reminderAt,
                deadline: _deadline,
                onChanged: (dt) => setState(() => _reminderAt = dt),
              ),
              const SizedBox(height: AppSizes.xxl),

              // ── Tags ──────────────────────────────────────────
              _FieldLabel(AppStrings.taskTags),
              const SizedBox(height: AppSizes.sm),
              TagInput(
                tags: _tags,
                onChanged: (tags) => setState(() => _tags = tags),
              ),
              const SizedBox(height: 36),

              // ── Save Button ───────────────────────────────────
              PrimaryButton(
                label: AppStrings.saveTask,
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _ReminderRow extends StatelessWidget {
  final DateTime? reminderAt;
  final DateTime? deadline;
  final ValueChanged<DateTime?> onChanged;

  const _ReminderRow({
    required this.reminderAt,
    required this.deadline,
    required this.onChanged,
  });

  String _formatTime(DateTime dt) {
    final d = '${dt.day}/${dt.month}/${dt.year}';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$d $h:$m';
  }

  Future<void> _pick(BuildContext context) async {
    final initDate = deadline ?? DateTime.now().add(const Duration(hours: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: reminderAt ?? initDate,
      firstDate: DateTime.now(),
      lastDate: initDate.add(const Duration(days: 365)),
    );
    if (picked == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(reminderAt ?? initDate),
    );
    if (time == null) return;

    onChanged(DateTime(picked.year, picked.month, picked.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              reminderAt != null
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              size: AppSizes.iconMd,
              color: reminderAt != null ? AppColors.accent : AppColors.textTertiary,
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                reminderAt != null ? _formatTime(reminderAt!) : 'Đặt thời gian nhắc',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: reminderAt != null
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
            ),
            if (reminderAt != null)
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
    );
  }
}
