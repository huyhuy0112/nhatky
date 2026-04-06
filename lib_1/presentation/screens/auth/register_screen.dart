import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onLoginTap;
  const RegisterScreen({super.key, this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: BLoC dispatch
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: widget.onLoginTap,
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 28),
                Text('Tạo tài khoản\nmới.', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Chỉ mất vài giây để bắt đầu.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 36),
                AppTextField(
                  controller: _nameCtrl,
                  label: AppStrings.fullName,
                  hint: 'Nguyễn Văn A',
                  validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: AppSizes.md),
                AppTextField(
                  controller: _emailCtrl,
                  label: AppStrings.email,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Vui lòng nhập email';
                    if (!v.contains('@')) return 'Email không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.md),
                AppTextField(
                  controller: _passCtrl,
                  label: AppStrings.password,
                  hint: '••••••••',
                  obscureText: _obscurePass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: AppColors.textTertiary,
                      size: AppSizes.iconMd,
                    ),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                    if (v.length < 6) return 'Tối thiểu 6 ký tự';
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.md),
                AppTextField(
                  controller: _confirmCtrl,
                  label: AppStrings.confirmPassword,
                  hint: '••••••••',
                  obscureText: _obscurePass,
                  validator: (v) {
                    if (v != _passCtrl.text) return 'Mật khẩu không khớp';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: AppStrings.register,
                  isLoading: _isLoading,
                  onPressed: _onRegister,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.hasAccount, style: Theme.of(context).textTheme.bodySmall),
                    GestureDetector(
                      onTap: widget.onLoginTap,
                      child: Text(
                        AppStrings.login,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
