import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/journal_entry.dart';
import '../../models/mood_type.dart';
import '../../shared/widgets/mood_chip.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  MoodType _selectedMood = MoodType.joyful;
  final Set<String> _selectedTags = <String>{};

  final List<String> _suggestedTags = const [
    'công việc',
    'gia đình',
    'suy ngẫm',
    'biết ơn',
    'sức khỏe',
    'thư giãn',
    'mục tiêu',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: DateTime.now(),
      mood: _selectedMood,
      tags: _selectedTags.toList(),
      isFavorite: false,
    );

    Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viết nhật kí mới'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF725CFF), Color(0xFF957CFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lưu lại ngày hôm nay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Một vài dòng chân thật hôm nay có thể trở thành điều quý giá khi bạn đọc lại sau này.',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tiêu đề',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Hãy nhập tiêu đề cho trang nhật kí';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ví dụ: Một ngày thật nhiều năng lượng',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tâm trạng',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: MoodType.values
                      .map(
                        (mood) => MoodChip(
                          mood: mood,
                          isSelected: _selectedMood == mood,
                          onTap: () {
                            setState(() {
                              _selectedMood = mood;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nội dung',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().length < 20) {
                      return 'Hãy viết ít nhất 20 ký tự';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText:
                        'Hôm nay bạn nghĩ gì, cảm thấy gì, đã trải qua điều gì?',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Gắn thẻ nhanh',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _suggestedTags.map((tag) {
                    final selected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor: AppTheme.primary.withOpacity(0.14),
                      checkmarkColor: AppTheme.primary,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save_rounded),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Lưu trang nhật kí'),
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
