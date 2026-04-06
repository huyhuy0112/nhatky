import 'package:flutter/material.dart';

import '../../data/mock_journal_entries.dart';
import '../../models/journal_entry.dart';
import '../home/home_screen.dart';
import '../journal/journal_detail_screen.dart';
import '../journal/journal_list_screen.dart';
import '../journal/new_entry_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  late List<JournalEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = [...MockJournalEntries.items]
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _openNewEntry() async {
    final result = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(
        builder: (_) => const NewEntryScreen(),
      ),
    );

    if (result == null) return;

    setState(() {
      _entries = [result, ..._entries]
        ..sort((a, b) => b.date.compareTo(a.date));
      _currentIndex = 1;
    });
  }

  void _openDetail(JournalEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalDetailScreen(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(entries: _entries, onEntryTap: _openDetail),
      JournalListScreen(entries: _entries, onEntryTap: _openDetail),
      ProfileScreen(entries: _entries),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewEntry,
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('Viết hôm nay'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Nhật kí',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}
