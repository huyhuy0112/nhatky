import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/journal_entry.dart';
import '../../shared/widgets/section_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.entries,
  });

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final favoritesCount = entries.where((entry) => entry.isFavorite).length;
    final tags = entries.expand((entry) => entry.tags).toSet().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B66FF), Color(0xFF5A8DFF)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Người viết của hôm nay',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Một không gian nhỏ để cất giữ suy nghĩ, cảm xúc và hành trình trưởng thành của bạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ProfileMetric(
                        value: '${entries.length}',
                        label: 'Bài viết',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ProfileMetric(
                        value: '$favoritesCount',
                        label: 'Yêu thích',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ProfileMetric(
                        value: '${tags.length}',
                        label: 'Thẻ',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(
            title: 'Nhịp sống cá nhân',
            subtitle: 'Một số thói quen gợi ý để viết đều hơn',
          ),
          const SizedBox(height: 14),
          const _ChecklistTile(
            icon: Icons.wb_sunny_outlined,
            title: 'Ghi lại 1 điều biết ơn mỗi sáng',
            subtitle: 'Tạo thói quen bắt đầu ngày mới tích cực.',
          ),
          const SizedBox(height: 12),
          const _ChecklistTile(
            icon: Icons.nights_stay_outlined,
            title: 'Tóm tắt cảm xúc trước khi ngủ',
            subtitle: 'Chỉ cần 3 đến 5 câu ngắn để nhìn lại một ngày.',
          ),
          const SizedBox(height: 12),
          const _ChecklistTile(
            icon: Icons.local_fire_department_outlined,
            title: 'Duy trì streak viết ít nhất 3 ngày/tuần',
            subtitle: 'Đều đặn quan trọng hơn viết thật nhiều.',
          ),
          const SizedBox(height: 24),
          const SectionTitle(
            title: 'Thiết lập gợi ý',
            subtitle: 'Phần này đang là giao diện mẫu frontend',
          ),
          const SizedBox(height: 14),
          const _SettingRow(
            icon: Icons.lock_outline_rounded,
            title: 'Khóa ứng dụng',
            subtitle: 'Thêm mã PIN hoặc sinh trắc học',
          ),
          const SizedBox(height: 12),
          const _SettingRow(
            icon: Icons.palette_outlined,
            title: 'Giao diện',
            subtitle: 'Sáng, tối hoặc theo hệ thống',
          ),
          const SizedBox(height: 12),
          const _SettingRow(
            icon: Icons.cloud_outlined,
            title: 'Đồng bộ dữ liệu',
            subtitle: 'Kết nối backend trong giai đoạn tiếp theo',
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.5,
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

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.textPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
