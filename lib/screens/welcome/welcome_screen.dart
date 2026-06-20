import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/space_journalism_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              const SpaceJournalismIllustration(size: 240),
              const SizedBox(height: 36),
              const Text(
                'Welcome to SpaceNews Core Application',
                textAlign: TextAlign.center,
                style: AppTextStyleHeading,
              ),
              const SizedBox(height: 12),
              const Text(
                'Berita antariksa & teknologi internasional terkini, '
                'langsung dari sumber tepercaya — kapan saja, di mana saja.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Mulai Sekarang',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.register);
                },
                child: const Text(
                  'Belum punya akun? Daftar',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle AppTextStyleHeading = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
  height: 1.3,
);
