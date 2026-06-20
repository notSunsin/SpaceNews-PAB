/// Centralized named-route constants for the primary auth/navigation
/// flow. Screens that need to carry complex objects (e.g. DetailScreen
/// with an Article) are pushed directly with MaterialPageRoute instead
/// of named routes, which keeps argument passing type-safe.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String welcome = '/welcome';
  static const String mainNavigation = '/main';
}
