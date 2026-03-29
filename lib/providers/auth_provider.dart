// ============================================================
//  auth_provider.dart — Riverpod Providers (Employee only)
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../notifiers/auth_notifier.dart';

/// Primary auth notifier provider.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Currently authenticated employee (null if not logged in).
final currentUserProvider = Provider<AppUser?>((ref) {
  final state = ref.watch(authNotifierProvider);
  return state is AuthAuthenticated ? state.user : null;
});

/// Convenience boolean — true when logged in.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// True while login is in progress.
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) is AuthLoading;
});

/// Current error message (null if none).
final authErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(authNotifierProvider);
  return state is AuthError ? state.message : null;
});
