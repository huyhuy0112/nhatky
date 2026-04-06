import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';
import '../../widgets/task_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAddTask;
  const HomeScreen({super.key, this.onAddTask});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 18) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding, 24, AppSizes.screenPadding, 0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting() + ',',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Hãy bắt đầu ngày mới!', // TODO: replace with user name
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                    // Avatar
                    GestureDetector(
                      onTap: () {}, // TODO: go to profile
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.accent,
                          size: AppSizes.iconLg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stats Row ───────────────────────────────────────
            SliverToBoxAdapter(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is! TaskLoaded) return const SizedBox(height: AppSizes.xl);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 20, AppSizes.screenPadding, 0,
                    ),
                    child: Row(
                      children: [
                        StatChip(
                          label: 'Hôm nay',
                          value: '${state.todayTasks.length}',
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        StatChip(
                          label: 'Quá hạn',
                          value: '${state.overdueTasks.length}',
                          color: AppColors.overdue,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        StatChip(
                          label: 'Xong',
                          value: '${state.completedTasks.length}',
                          color: AppColors.completed,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Task Sections ────────────────────────────────────
            BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const SliverToBoxAdapter(child: LoadingShimmer());
                }
                if (state is TaskError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(state.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        )),
                    ),
                  );
                }
                if (state is TaskLoaded) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // Overdue
                      if (state.overdueTasks.isNotEmpty) ...[
                        SectionHeader(
                          title: AppStrings.overdueTasks,
                          count: state.overdueTasks.length,
                          color: AppColors.overdue,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...state.overdueTasks.map((task) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.screenPadding, 0, AppSizes.screenPadding, AppSizes.sm,
                          ),
                          child: TaskCard(task: task),
                        )),
                        const SizedBox(height: AppSizes.lg),
                      ],

                      // Today
                      SectionHeader(
                        title: AppStrings.todayTasks,
                        count: state.todayTasks.length,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      if (state.todayTasks.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                          child: EmptyState(
                            icon: Icons.task_alt_rounded,
                            message: 'Không có task nào hôm nay',
                            subMessage: 'Nhấn + để thêm task mới',
                          ),
                        )
                      else
                        ...state.todayTasks.map((task) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.screenPadding, 0, AppSizes.screenPadding, AppSizes.sm,
                          ),
                          child: TaskCard(task: task),
                        )),
                      const SizedBox(height: AppSizes.xl),

                      // Upcoming
                      if (state.upcomingTasks.isNotEmpty) ...[
                        SectionHeader(
                          title: AppStrings.upcomingTasks,
                          count: state.upcomingTasks.length,
                          color: AppColors.upcoming,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...state.upcomingTasks.map((task) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.screenPadding, 0, AppSizes.screenPadding, AppSizes.sm,
                          ),
                          child: TaskCard(task: task),
                        )),
                        const SizedBox(height: AppSizes.xl),
                      ],
                    ]),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            // Bottom padding for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
