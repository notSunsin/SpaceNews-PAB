import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _instagramController;

  final FirestoreService _firestoreService = FirestoreService();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _instagramController =
        TextEditingController(text: widget.user.instagram.replaceAll('@', ''));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _firestoreService.updateUserProfile(
        uid: widget.user.uid,
        fullName: _nameController.text.trim(),
        instagram: _instagramController.text.trim(),
      );

      if (!mounted) return;
      AppSnackbar.showSuccess(context, 'Profil berhasil diperbarui.');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Gagal menyimpan profil: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _instagramController,
                  label: 'Instagram',
                  icon: Icons.camera_alt_outlined,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.user.email,
                  enabled: false,
                  style: const TextStyle(color: AppColors.textSecondary),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface.withOpacity(0.6),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Simpan',
                  isLoading: _isSaving,
                  onPressed: _onSavePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
