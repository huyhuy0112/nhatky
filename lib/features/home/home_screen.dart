import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_type.dart';
import '../../shared/widgets/journal_card.dart';
import '../../shared/widgets/mood_chip.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/stat_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.entries,
    required this.onEntryTap,
  });

  final List<JournalEntry> entries;
  final ValueChanged<JournalEntry> onEntryTap;

  MoodType get _topMood {
    if (entries.isEmpty) return MoodType.calm;

    final counts = <MoodType, int>{};
    for (final entry in entries) {
      counts.update(entry.mood, (value) => value + 1, ifAbsent: () => 1);
    }

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  @override
  Widget build(BuildContext context) {
    final recentEntries = entries.take(3).toList();
    final favoritesCount = entries.where((entry) => entry.isFavorite).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Xin chào 👋',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Nhật kí của tôi',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B66FF), Color(0xFF5A8DFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảm xúc hôm nay',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Viết vài dòng để lắng nghe chính mình.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ứng dụng này tập trung vào cảm xúc, ký ức và những ghi chép ngắn giúp bạn nhìn lại hành trình của bản thân.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(
            title: 'Tâm trạng nổi bật',
            subtitle: 'Từ những mục bạn đã viết gần đây',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: MoodType.values
                .map(
                  (mood) => MoodChip(
                    mood: mood,
                    isSelected: _topMood == mood,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              StatTile(
                value: '${entries.length}',
                label: 'Trang đã viết',
                icon: Icons.menu_book_rounded,
              ),
              const SizedBox(width: 12),
              StatTile(
                value: '$favoritesCount',
                label: 'Mục yêu thích',
                icon: Icons.favorite_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle(
            title: 'Gần đây',
            subtitle: 'Những mục mới nhất của bạn',
          ),
          const SizedBox(height: 14),
          ...recentEntries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: JournalCard(
                entry: entry,
                onTap: () => onEntryTap(entry),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gợi ý viết hôm nay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Điều gì hôm nay khiến bạn biết ơn?\n'
                  '• Bạn muốn giữ lại khoảnh khắc nào lâu nhất?\n'
                  '• Một điều nhỏ bạn muốn làm tốt hơn vào ngày mai là gì?',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
