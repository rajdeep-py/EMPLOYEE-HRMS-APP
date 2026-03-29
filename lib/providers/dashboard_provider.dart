// ============================================================
//  dashboard_provider.dart — Riverpod Providers for Dashboard
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';
import '../notifiers/dashboard_notifier.dart';

/// Primary dashboard notifier provider.
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});

/// Today's attendance record (null if not yet loaded).
final todayAttendanceProvider = Provider<AttendanceRecord?>((ref) {
  return ref.watch(dashboardNotifierProvider).todayRecord;
});

/// Current check-in status.
final attendanceStatusProvider = Provider<AttendanceStatus>((ref) {
  return ref.watch(dashboardNotifierProvider).status;
});

/// True while check-in action is in progress.
final isCheckingInProvider = Provider<bool>((ref) {
  return ref.watch(dashboardNotifierProvider).isCheckingIn;
});

/// True while check-out action is in progress.
final isCheckingOutProvider = Provider<bool>((ref) {
  return ref.watch(dashboardNotifierProvider).isCheckingOut;
});

/// True while initial data is loading.
final isDashboardLoadingProvider = Provider<bool>((ref) {
  return ref.watch(dashboardNotifierProvider).isLoading;
});

/// Current error message (null if none).
final dashboardErrorProvider = Provider<String?>((ref) {
  return ref.watch(dashboardNotifierProvider).error;
});
