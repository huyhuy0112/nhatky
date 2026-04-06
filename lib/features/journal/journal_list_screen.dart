import 'package:flutter/material.dart';

import '../../models/journal_entry.dart';
import '../../shared/widgets/empty_state_card.dart';
import '../../shared/widgets/journal_card.dart';
import '../../shared/widgets/section_title.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({
    super.key,
    required this.entries,
    required this.onEntryTap,
  });

  final List<JournalEntry> entries;
  final ValueChanged<JournalEntry> onEntryTap;

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredEntries = widget.entries.where((entry) {
      final keyword = _query.toLowerCase();
      return entry.title.toLowerCase().contains(keyword) ||
          entry.content.toLowerCase().contains(keyword) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(keyword));
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              children: [
                const SectionTitle(
                  title: 'Tất cả nhật kí',
                  subtitle: 'Tìm kiếm theo tiêu đề, nội dung hoặc thẻ',
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _query = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm nhật kí...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 18),
                if (filteredEntries.isEmpty)
                  const EmptyStateCard(
                    title: 'Chưa có kết quả phù hợp',
                    message:
                        'Hãy thử từ khóa khác hoặc tạo thêm một mục nhật kí mới để bắt đầu hành trình của bạn.',
                    icon: Icons.auto_stories_rounded,
                  )
                else
                  ...filteredEntries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: JournalCard(
                        entry: entry,
                        onTap: () => widget.onEntryTap(entry),
                      ),
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
