import '../models/journal_entry.dart';
import '../models/mood_type.dart';

class MockJournalEntries {
  MockJournalEntries._();

  static List<JournalEntry> items = [
    JournalEntry(
      id: 'e1',
      title: 'Một ngày nhẹ tênh',
      content:
          'Sáng nay mình dậy sớm hơn thường lệ, pha một ly cà phê và ngồi bên cửa sổ nghe nhạc. Mọi thứ diễn ra chậm rãi nhưng đủ để mình thấy dễ chịu. Công việc hôm nay không quá áp lực và mình cũng đã hoàn thành những việc quan trọng nhất.',
      date: DateTime(2026, 4, 6, 7, 30),
      mood: MoodType.joyful,
      tags: ['cà phê', 'buổi sáng', 'biết ơn'],
      isFavorite: true,
    ),
    JournalEntry(
      id: 'e2',
      title: 'Muốn sống chậm lại',
      content:
          'Mình nhận ra dạo này bản thân đang cố gắng quá nhiều để chạy theo tiến độ. Tối nay mình quyết định tắt bớt thông báo, đi bộ một vòng ngắn rồi về viết vài dòng để nhắc bản thân rằng nghỉ ngơi cũng là một phần của hành trình.',
      date: DateTime(2026, 4, 5, 21, 10),
      mood: MoodType.calm,
      tags: ['chữa lành', 'thư giãn'],
    ),
    JournalEntry(
      id: 'e3',
      title: 'Tập trung để hoàn thành',
      content:
          'Hôm nay mình dành gần trọn buổi chiều để hoàn thiện phần giao diện cho dự án. Có lúc khá căng nhưng cảm giác nhìn mọi thứ dần rõ ràng hơn thực sự rất đã. Mình thích những ngày mình có thể làm việc sâu và ít bị phân tâm.',
      date: DateTime(2026, 4, 4, 16, 45),
      mood: MoodType.focused,
      tags: ['công việc', 'flutter', 'tiến bộ'],
      isFavorite: true,
    ),
    JournalEntry(
      id: 'e4',
      title: 'Ngày hơi cạn năng lượng',
      content:
          'Có lẽ mình đã ngủ chưa đủ. Cả ngày mọi thứ trôi qua khá chậm và mình hơi khó tập trung. Tuy vậy, mình vẫn cố gắng hoàn thành những việc thiết yếu và cho phép bản thân nghỉ sớm hơn một chút.',
      date: DateTime(2026, 4, 3, 20, 15),
      mood: MoodType.tired,
      tags: ['nghỉ ngơi', 'sức khỏe'],
    ),
    JournalEntry(
      id: 'e5',
      title: 'Một chút lắng xuống',
      content:
          'Tối nay mình nhớ về một vài chuyện cũ. Không hẳn là buồn, chỉ là cảm giác hơi trầm xuống. Viết ra giúp mình sắp xếp suy nghĩ tốt hơn và nhẹ lòng hơn một chút.',
      date: DateTime(2026, 4, 2, 22, 0),
      mood: MoodType.sad,
      tags: ['cảm xúc', 'suy ngẫm'],
    ),
  ];
}
