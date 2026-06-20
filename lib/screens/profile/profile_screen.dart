import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/session_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_snackbar.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final SessionService _sessionService = SessionService();

  bool _isLoggingOut = false;

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _sessionService.clearSession();
      await _authService.logout();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.register,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal logout: $e');
      setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: uid == null
          ? const Center(child: Text('Silakan login terlebih dahulu.'))
          : StreamBuilder<AppUser?>(
              stream: _firestoreService.userProfileStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final user = snapshot.data;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColors.primary.withOpacity(0.08),
                            backgroundImage: (user?.photoUrl.isNotEmpty ?? false)
                                ? NetworkImage(user!.photoUrl)
                                : null,
                            child: (user?.photoUrl.isEmpty ?? true)
                                ? const Icon(Icons.person,
                                    size: 48, color: AppColors.primary)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.fullName ?? '-',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? _authService.currentUser?.email ?? '-',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _ProfileInfoTile(
                      icon: Icons.badge_outlined,
                      label: 'Nama Lengkap',
                      value: user?.fullName ?? '-',
                    ),
                    const SizedBox(height: 12),
                    _ProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? _authService.currentUser?.email ?? '-',
                    ),
                    const SizedBox(height: 12),
                    _ProfileInfoTile(
                      icon: Icons.camera_alt_outlined,
                      label: 'Instagram',
                      value: (user?.instagram.isEmpty ?? true)
                          ? '-'
                          : '@${user!.instagram.replaceAll('@', '')}',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: (_isLoggingOut || user == null)
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditProfileScreen(user: user),
                                  ),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _isLoggingOut ? null : _confirmLogout,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _isLoggingOut
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.error,
                                ),
                              )
                            : const Icon(Icons.logout),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
