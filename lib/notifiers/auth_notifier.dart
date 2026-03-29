// ============================================================
//  auth_notifier.dart — AuthState + AuthNotifier (Employee only)
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

// ─────────────────────────────────────────────
//  AuthState — Sealed hierarchy
// ─────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ─────────────────────────────────────────────
//  AuthNotifier
// ─────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial());

  /// Employee login — stub, replace with real API call.
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    state = const AuthLoading();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (phone.isEmpty || phone.length < 10) {
      state = const AuthError('Please enter a valid 10-digit phone number.');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      state = const AuthError('Password must be at least 6 characters.');
      return;
    }

    // TODO: Replace with actual API call
    final mockUser = AppUser(
      id:    'emp_001',
      name:  'Rajdeep Dey',
      phone: phone,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    state = AuthAuthenticated(mockUser);
  }

  /// Clear auth state — logout.
  void logout() => state = const AuthInitial();

  /// Reset error back to initial.
  void resetError() {
    if (state is AuthError) state = const AuthInitial();
  }
}
