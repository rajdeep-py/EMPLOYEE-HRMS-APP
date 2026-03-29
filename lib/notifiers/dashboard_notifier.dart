// ============================================================
//  dashboard_notifier.dart — DashboardState + DashboardNotifier
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../models/attendance.dart';

// ─────────────────────────────────────────────
//  DashboardState
// ─────────────────────────────────────────────

class DashboardState {
  final AttendanceRecord? todayRecord;
  final bool isLoading;
  final bool isCheckingIn;
  final bool isCheckingOut;
  final String? error;

  const DashboardState({
    this.todayRecord,
    this.isLoading    = false,
    this.isCheckingIn = false,
    this.isCheckingOut = false,
    this.error,
  });

  AttendanceStatus get status =>
      todayRecord?.status ?? AttendanceStatus.checkedOut;

  bool get isCheckedIn => status == AttendanceStatus.checkedIn;

  DashboardState copyWith({
    AttendanceRecord? todayRecord,
    bool? isLoading,
    bool? isCheckingIn,
    bool? isCheckingOut,
    String? error,
  }) {
    return DashboardState(
      todayRecord:   todayRecord   ?? this.todayRecord,
      isLoading:     isLoading     ?? this.isLoading,
      isCheckingIn:  isCheckingIn  ?? this.isCheckingIn,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      error:         error,   // null clears the error
    );
  }
}

// ─────────────────────────────────────────────
//  DashboardNotifier
// ─────────────────────────────────────────────

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState());

  final _picker = ImagePicker();

  /// Load today's attendance record.
  Future<void> loadTodayRecord(String employeeId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Replace with real API call
    state = state.copyWith(isLoading: false);
  }

  /// Check In: capture selfie + location, then post.
  Future<void> checkIn(String employeeId) async {
    state = state.copyWith(isCheckingIn: true, error: null);
    try {
      // 1. Selfie
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );
      if (photo == null) {
        state = state.copyWith(isCheckingIn: false, error: 'Selfie is required for check-in.');
        return;
      }

      // 2. Location
      final position = await _getLocation();

      // 3. Build record
      final now = DateTime.now();
      final record = AttendanceRecord(
        id:               'att_${now.millisecondsSinceEpoch}',
        employeeId:       employeeId,
        date:             DateTime(now.year, now.month, now.day),
        checkInTime:      now,
        checkInPhotoPath: photo.path,
        checkInLatitude:  position?.latitude,
        checkInLongitude: position?.longitude,
        checkInAddress:   position != null
            ? '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'
            : 'Location unavailable',
        status: AttendanceStatus.checkedIn,
      );

      // TODO: POST record to API
      state = state.copyWith(isCheckingIn: false, todayRecord: record);
    } catch (e) {
      state = state.copyWith(isCheckingIn: false, error: e.toString());
    }
  }

  /// Check Out: capture selfie + location, then post.
  Future<void> checkOut(String employeeId) async {
    if (state.todayRecord == null) return;
    state = state.copyWith(isCheckingOut: true, error: null);
    try {
      // 1. Selfie
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );
      if (photo == null) {
        state = state.copyWith(isCheckingOut: false, error: 'Selfie is required for check-out.');
        return;
      }

      // 2. Location
      final position = await _getLocation();
      final now = DateTime.now();

      final updated = state.todayRecord!.copyWith(
        checkOutTime:      now,
        checkOutPhotoPath: photo.path,
        checkOutLatitude:  position?.latitude,
        checkOutLongitude: position?.longitude,
        checkOutAddress: position != null
            ? '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'
            : 'Location unavailable',
        status: AttendanceStatus.checkedOut,
      );

      // TODO: PATCH record to API
      state = state.copyWith(isCheckingOut: false, todayRecord: updated);
    } catch (e) {
      state = state.copyWith(isCheckingOut: false, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);

  // ── Location helper ──────────────────────────────────────────
  Future<Position?> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return null;
      }
      if (perm == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }
}
