import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  List<Task> _getTasksForDay(List<Task> allTasks, DateTime day) {
    return allTasks.where((task) {
      if (task.deadline == null) return false;
      final d = task.deadline!;
      return d.year == day.year && d.month == day.month && d.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            final allTasks = state is TaskLoaded ? state.tasks : <Task>[];
            final selectedTasks = _selectedDay != null
                ? _getTasksForDay(allTasks, _selectedDay!)
                : <Task>[];

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 24, AppSizes.screenPadding, 16,
                    ),
                    child: Text(
                      AppStrings.calendar,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),

                // ── Calendar ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TableCalendar<Task>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      calendarFormat: _format,
                      eventLoader: (day) => _getTasksForDay(allTasks, day),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                      onFormatChanged: (f) => setState(() => _format = f),
                      onPageChanged: (day) => _focusedDay = day,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
                        weekendTextStyle: Theme.of(context).textTheme.bodyMedium!,
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.accentLight,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                        markerDecoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        markerSize: 5,
                        markersMaxCount: 3,
                        markersAnchor: 1.5,
                        cellMargin: const EdgeInsets.all(4),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        formatButtonTextStyle: Theme.of(context).textTheme.labelMedium!,
                        leftChevronIcon: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textSecondary,
                        ),
                        rightChevronIcon: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                        ),
                        headerPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        weekendStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Selected Day Header ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 0, AppSizes.screenPadding, 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedDay != null
                              ? _formatSelectedDay(_selectedDay!)
                              : 'Chọn một ngày',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        if (selectedTasks.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              '${selectedTasks.length}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Tasks for selected day ────────────────────────
                if (selectedTasks.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyState(
                      icon: Icons.event_available_rounded,
                      message: AppStrings.noTasksOnDay,
                      compact: true,
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.screenPadding, 0, AppSizes.screenPadding, AppSizes.sm,
                        ),
                        child: TaskCard(task: selectedTasks[i]),
                      ),
                      childCount: selectedTasks.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatSelectedDay(DateTime day) {
    final now = DateTime.now();
    if (isSameDay(day, now)) return 'Hôm nay';
    if (isSameDay(day, now.add(const Duration(days: 1)))) return 'Ngày mai';
    if (isSameDay(day, now.subtract(const Duration(days: 1)))) return 'Hôm qua';
    const months = ['tháng 1', 'tháng 2', 'tháng 3', 'tháng 4', 'tháng 5', 'tháng 6',
                    'tháng 7', 'tháng 8', 'tháng 9', 'tháng 10', 'tháng 11', 'tháng 12'];
    return '${day.day} ${months[day.month - 1]}, ${day.year}';
  }
}
