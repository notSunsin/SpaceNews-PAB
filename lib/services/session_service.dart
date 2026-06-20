import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences (local storage) used to
/// remember the login session across app restarts, so the Splash
/// Screen knows whether to route straight to Home or to Welcome/Login.
class SessionService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUid = 'uid';
  static const _keyEmail = 'email';

  Future<void> saveSession({required String uid, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyEmail, email);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }

  /// Clears the local session — called on logout, alongside
  /// FirebaseAuth.signOut().
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUid);
    await prefs.remove(_keyEmail);
  }
}
