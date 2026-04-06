import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _reminderSound = true;
  String _language = 'Tiếng Việt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding, 24, AppSizes.screenPadding, 24,
                ),
                child: Text(
                  AppStrings.settings,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),

            // ── Profile Card ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.accent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Người dùng', // TODO: from auth state
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'user@example.com',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textTertiary,
                        size: AppSizes.iconMd,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Appearance Section ────────────────────────────
            _SectionHeader(label: 'Giao diện'),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _ToggleTile(
                    icon: Icons.dark_mode_rounded,
                    label: AppStrings.darkMode,
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Notifications Section ──────────────────────────
            _SectionHeader(label: 'Thông báo'),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _ToggleTile(
                    icon: Icons.notifications_rounded,
                    label: AppStrings.notifications,
                    value: _notifications,
                    onChanged: (v) => setState(() => _notifications = v),
                  ),
                  _Divider(),
                  _ToggleTile(
                    icon: Icons.volume_up_rounded,
                    label: 'Âm thanh nhắc nhở',
                    value: _reminderSound,
                    onChanged: (v) => setState(() => _reminderSound = v),
                    enabled: _notifications,
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── General Section ────────────────────────────────
            _SectionHeader(label: 'Chung'),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _NavTile(
                    icon: Icons.language_rounded,
                    label: AppStrings.language,
                    value: _language,
                    onTap: () => _showLanguagePicker(),
                  ),
                  _Divider(),
                  _NavTile(
                    icon: Icons.category_rounded,
                    label: 'Quản lý danh mục',
                    onTap: () {},
                  ),
                  _Divider(),
                  _NavTile(
                    icon: Icons.cloud_sync_rounded,
                    label: 'Đồng bộ dữ liệu',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── About Section ──────────────────────────────────
            _SectionHeader(label: 'Thông tin'),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _NavTile(
                    icon: Icons.info_outline_rounded,
                    label: AppStrings.about,
                    value: 'v1.0.0',
                    onTap: () => _showAbout(),
                  ),
                  _Divider(),
                  _NavTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Chính sách bảo mật',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Logout ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                child: _SettingsGroup(
                  children: [
                    _NavTile(
                      icon: Icons.logout_rounded,
                      label: AppStrings.logout,
                      onTap: _confirmLogout,
                      danger: true,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: Text(AppStrings.logout,
          style: Theme.of(context).textTheme.headlineSmall),
        content: Text(AppStrings.logoutConfirm,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: dispatch AuthBloc logout event
            },
            child: const Text(AppStrings.logout,
              style: TextStyle(color: AppColors.priorityHigh)),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Chọn ngôn ngữ'),
        actions: ['Tiếng Việt', 'English'].map((lang) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _language = lang);
              Navigator.pop(context);
            },
            child: Text(lang),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: 'v1.0.0',
      applicationLegalese: '© 2024 Focusd',
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding + 4, 0, AppSizes.screenPadding, 8,
        ),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg, vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconMd, color: AppColors.textSecondary),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppColors.accent,
              trackColor: AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool danger;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.priorityHigh : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg, vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconMd, color: color),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: danger ? AppColors.priorityHigh : null,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            const SizedBox(width: AppSizes.xs),
            if (!danger)
              Icon(
                Icons.chevron_right_rounded,
                size: AppSizes.iconMd,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: AppSizes.lg + AppSizes.iconMd + AppSizes.md),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}
