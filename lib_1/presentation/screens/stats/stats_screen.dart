import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _period = 'week'; // 'week' | 'month'

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            final tasks = state is TaskLoaded ? state.tasks : <Task>[];
            final stats = _computeStats(tasks);

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 24, AppSizes.screenPadding, 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.statistics,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        // Period toggle
                        Container(
                          height: 36,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _PeriodBtn(
                                label: 'Tuần',
                                selected: _period == 'week',
                                onTap: () => setState(() => _period = 'week'),
                              ),
                              _PeriodBtn(
                                label: 'Tháng',
                                selected: _period == 'month',
                                onTap: () => setState(() => _period = 'month'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Summary Cards ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: AppStrings.totalCompleted,
                            value: '${stats.completed}',
                            icon: Icons.task_alt_rounded,
                            color: AppColors.completed,
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: _SummaryCard(
                            label: AppStrings.completionRate,
                            value: '${stats.rate.toStringAsFixed(0)}%',
                            icon: Icons.pie_chart_rounded,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: _SummaryCard(
                            label: AppStrings.streak,
                            value: '${stats.streak}',
                            subLabel: AppStrings.streakDays,
                            icon: Icons.local_fire_department_rounded,
                            color: AppColors.priorityHigh,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Completion Bar Chart ─────────────────────────
                SliverToBoxAdapter(
                  child: _ChartCard(
                    title: 'Task hoàn thành',
                    subtitle: _period == 'week' ? '7 ngày qua' : '4 tuần qua',
                    child: SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          barGroups: _buildBarGroups(stats.dailyCompleted),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (v, _) => Text(
                                  v.toInt().toString(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  final labels = _period == 'week'
                                      ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                                      : ['W1', 'W2', 'W3', 'W4'];
                                  final i = v.toInt();
                                  if (i < 0 || i >= labels.length) return const SizedBox();
                                  return Text(
                                    labels[i],
                                    style: Theme.of(context).textTheme.labelSmall,
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: AppColors.border,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ── Priority Pie Chart ────────────────────────────
                SliverToBoxAdapter(
                  child: _ChartCard(
                    title: AppStrings.tasksByPriority,
                    subtitle: 'Phân bổ theo độ ưu tiên',
                    child: SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: _buildPieSections(stats.byPriority),
                                centerSpaceRadius: 48,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LegendItem(label: 'Cao', color: AppColors.priorityHigh, value: stats.byPriority['high'] ?? 0),
                              _LegendItem(label: 'TB', color: AppColors.priorityMedium, value: stats.byPriority['medium'] ?? 0),
                              _LegendItem(label: 'Thấp', color: AppColors.priorityLow, value: stats.byPriority['low'] ?? 0),
                              _LegendItem(label: 'Không', color: AppColors.priorityNone, value: stats.byPriority['none'] ?? 0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Productivity Score ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 16, AppSizes.screenPadding, 0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.white, size: 36),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.productivityScore,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${stats.score}/100',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircularProgressIndicator(
                            value: stats.score / 100,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 6,
                          ),
                        ],
                      ),
                    ),
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

  List<BarChartGroupData> _buildBarGroups(List<int> data) {
    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i].toDouble(),
            color: AppColors.accent,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 10,
              color: AppColors.surfaceVariant,
            ),
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _buildPieSections(Map<String, int> data) {
    final total = data.values.fold(0, (a, b) => a + b);
    if (total == 0) return [PieChartSectionData(value: 1, color: AppColors.border, showTitle: false)];

    return [
      PieChartSectionData(
        value: (data['high'] ?? 0).toDouble(),
        color: AppColors.priorityHigh,
        showTitle: false,
        radius: 44,
      ),
      PieChartSectionData(
        value: (data['medium'] ?? 0).toDouble(),
        color: AppColors.priorityMedium,
        showTitle: false,
        radius: 44,
      ),
      PieChartSectionData(
        value: (data['low'] ?? 0).toDouble(),
        color: AppColors.priorityLow,
        showTitle: false,
        radius: 44,
      ),
      PieChartSectionData(
        value: (data['none'] ?? 0).toDouble(),
        color: AppColors.priorityNone,
        showTitle: false,
        radius: 44,
      ),
    ];
  }

  _Stats _computeStats(List<Task> tasks) {
    final completed = tasks.where((t) => t.isCompleted).length;
    final total = tasks.length;
    final rate = total == 0 ? 0.0 : (completed / total * 100);
    final score = (rate * 0.7 + (completed > 5 ? 30 : completed * 6)).clamp(0, 100).toDouble();

    // Daily completed (last 7 days mock)
    final dailyCompleted = List.generate(7, (i) => i % 3);

    // By priority
    final byPriority = {
      'high': tasks.where((t) => t.priority == Priority.high).length,
      'medium': tasks.where((t) => t.priority == Priority.medium).length,
      'low': tasks.where((t) => t.priority == Priority.low).length,
      'none': tasks.where((t) => t.priority == Priority.none).length,
    };

    return _Stats(
      completed: completed,
      rate: rate,
      streak: 3, // TODO: compute from actual data
      dailyCompleted: dailyCompleted,
      byPriority: byPriority,
      score: score.toInt(),
    );
  }
}

class _Stats {
  final int completed;
  final double rate;
  final int streak;
  final List<int> dailyCompleted;
  final Map<String, int> byPriority;
  final int score;

  _Stats({
    required this.completed,
    required this.rate,
    required this.streak,
    required this.dailyCompleted,
    required this.byPriority,
    required this.score,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subLabel;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconMd, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: color),
          ),
          if (subLabel != null)
            Text(subLabel!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              )),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final int value;

  const _LegendItem({required this.label, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label: $value',
            style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _PeriodBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 1))]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
