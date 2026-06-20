import 'package:firebase_auth/firebase_auth.dart';

/// Wraps Firebase Authentication: register, login, logout, and
/// password-reset flows used by the Register / Login / Forgot
/// Password screens.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Registers a new user with email & password.
  /// Returns the created [User] on success.
  Future<User> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user == null) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Gagal membuat akun. Silakan coba lagi.',
      );
    }
    return credential.user!;
  }

  /// Signs in an existing user with email & password.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user == null) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Gagal masuk. Silakan coba lagi.',
      );
    }
    return credential.user!;
  }

  /// Sends a password-reset email via Firebase Auth.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Signs the current user out.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Maps common Firebase Auth error codes to friendly Indonesian messages.
  String messageFromException(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar. Silakan login.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'weak-password':
          return 'Password terlalu lemah (minimal 6 karakter).';
        case 'user-not-found':
          return 'Akun dengan email tersebut tidak ditemukan.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau password salah.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        case 'network-request-failed':
          return 'Tidak ada koneksi internet.';
        default:
          return error.message ?? 'Terjadi kesalahan. Silakan coba lagi.';
      }
    }
    return error.toString();
  }
}
