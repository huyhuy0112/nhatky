import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';
import '../../blocs/filter/filter_bloc.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/filter_bottom_sheet.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  bool _showSearch = false;
  late TabController _tabController;

  final List<String> _tabs = [
    AppStrings.all,
    AppStrings.active,
    AppStrings.completed,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<TaskBloc>().add(const LoadTasksEvent());
    } else {
      context.read<TaskBloc>().add(SearchTasksEvent(query));
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding, 20, AppSizes.screenPadding, 0,
              ),
              child: Row(
                children: [
                  if (!_showSearch)
                    Expanded(
                      child: Text(
                        AppStrings.navTasks,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  if (_showSearch)
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: true,
                        onChanged: _onSearch,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppStrings.search,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: AppSizes.iconMd,
                            color: AppColors.textTertiary,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  const SizedBox(width: AppSizes.sm),
                  _IconBtn(
                    icon: _showSearch ? Icons.close_rounded : Icons.search_rounded,
                    onTap: () {
                      setState(() {
                        _showSearch = !_showSearch;
                        if (!_showSearch) {
                          _searchCtrl.clear();
                          context.read<TaskBloc>().add(const LoadTasksEvent());
                        }
                      });
                    },
                  ),
                  const SizedBox(width: AppSizes.xs),
                  BlocBuilder<FilterBloc, FilterState>(
                    builder: (_, filter) {
                      return _IconBtn(
                        icon: Icons.tune_rounded,
                        hasIndicator: filter.hasActiveFilters,
                        onTap: _showFilterSheet,
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Tabs ─────────────────────────────────────────────
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  labelStyle: Theme.of(context).textTheme.labelLarge,
                  unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Task List ─────────────────────────────────────────
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) return const LoadingShimmer();
                  if (state is TaskError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                            color: AppColors.textTertiary, size: 40),
                          const SizedBox(height: 12),
                          Text(AppStrings.error,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            )),
                        ],
                      ),
                    );
                  }
                  if (state is TaskLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _TaskListView(tasks: state.tasks),
                        _TaskListView(
                          tasks: state.tasks.where((t) => !t.isCompleted).toList(),
                        ),
                        _TaskListView(
                          tasks: state.completedTasks,
                          isCompletedView: true,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _TaskListView extends StatelessWidget {
  final List tasks;
  final bool isCompletedView;

  const _TaskListView({required this.tasks, this.isCompletedView = false});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyState(
        icon: isCompletedView ? Icons.emoji_events_rounded : Icons.inbox_rounded,
        message: isCompletedView ? 'Chưa có task hoàn thành' : AppStrings.noTasks,
        subMessage: isCompletedView ? null : AppStrings.noTasksHint,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPadding, 0, AppSizes.screenPadding, 80,
      ),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (_, i) => TaskCard(task: tasks[i]),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasIndicator;

  const _IconBtn({required this.icon, required this.onTap, this.hasIndicator = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: AppSizes.iconMd, color: AppColors.textSecondary),
          ),
        ),
        if (hasIndicator)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
