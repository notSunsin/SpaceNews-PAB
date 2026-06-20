import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.sendPasswordResetEmail(_emailController.text);
      if (!mounted) return;
      setState(() => _emailSent = true);
      AppSnackbar.showSuccess(
        context,
        'Link reset password telah dikirim ke email Anda.',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, _authService.messageFromException(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masukkan email yang terdaftar. Kami akan mengirimkan '
                  'link untuk mengatur ulang password Anda.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Send to email',
                  isLoading: _isLoading,
                  onPressed: _onSendPressed,
                ),
                if (_emailSent) ...[
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Email terkirim. Silakan periksa kotak masuk Anda.',
                          style: TextStyle(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
