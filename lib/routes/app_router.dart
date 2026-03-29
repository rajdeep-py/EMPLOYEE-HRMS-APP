// ============================================================
//  app_router.dart — GoRouter Configuration (Employee only)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';

// ─────────────────────────────────────────────
//  Route paths
// ─────────────────────────────────────────────
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
}

// ─────────────────────────────────────────────
//  GoRouter provider
// ─────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  final authListenable = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: authListenable,

    redirect: (context, state) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final location = state.uri.path;

      // Splash handles its own navigation — never redirect from it.
      if (location == AppRoutes.splash) return null;

      // Authenticated + still on login → go home
      if (isAuthenticated && location == AppRoutes.login) {
        return AppRoutes.home;
      }

      // Not authenticated + trying to access home → back to login
      if (!isAuthenticated && location == AppRoutes.home) {
        return AppRoutes.login;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const _PlaceholderHome(),
      ),
    ],

    errorBuilder: (_, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
});

// ─────────────────────────────────────────────
//  Auth change notifier (bridges Riverpod → GoRouter)
// ─────────────────────────────────────────────
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(isAuthenticatedProvider, (prev, next) => notifyListeners());
  }
}

// ─────────────────────────────────────────────
//  Placeholder home screen (replace when ready)
// ─────────────────────────────────────────────
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '🏠 Home Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
