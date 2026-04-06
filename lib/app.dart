import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/app_shell.dart';

class PersonalJournalApp extends StatelessWidget {
  const PersonalJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nhật kí cá nhân',
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
