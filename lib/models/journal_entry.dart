import 'mood_type.dart';

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
    required this.tags,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String content;
  final DateTime date;
  final MoodType mood;
  final List<String> tags;
  final bool isFavorite;

  String get preview {
    if (content.length <= 120) return content;
    return '${content.substring(0, 120).trim()}...';
  }
}
