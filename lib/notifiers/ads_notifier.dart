// ============================================================
//  ads_notifier.dart — AdsState + AdsNotifier
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ads.dart';

// ─────────────────────────────────────────────
//  AdsState — Sealed hierarchy
// ─────────────────────────────────────────────

sealed class AdsState {
  const AdsState();
}

final class AdsInitial extends AdsState {
  const AdsInitial();
}

final class AdsLoading extends AdsState {
  const AdsLoading();
}

final class AdsLoaded extends AdsState {
  final List<Ad> ads;
  const AdsLoaded(this.ads);
}

final class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);
}

// ─────────────────────────────────────────────
//  AdsNotifier
// ─────────────────────────────────────────────

class AdsNotifier extends StateNotifier<AdsState> {
  AdsNotifier() : super(const AdsInitial());

  /// Load ads — stub uses local assets.
  /// TODO: Replace with real API/CMS call.
  Future<void> loadAds() async {
    state = const AdsLoading();

    await Future.delayed(const Duration(milliseconds: 600));

    // Mock ads using available local assets
    final mockAds = [
      const Ad(
        id:              'ad_001',
        tagline:         'Track Your Day,\nEffortlessly.',
        caption:         'Real-time attendance at your fingertips.',
        backgroundAsset: 'assets/logo/A24.png',
        buttonLabel:     'Explore Now',
        actionUrl:       '/attendance',
      ),
      const Ad(
        id:              'ad_002',
        tagline:         'Plan Ahead,\nWork Smarter.',
        caption:         'View upcoming holidays and plan your time off.',
        backgroundAsset: 'assets/logo/director.jpeg',
        buttonLabel:     'View Holidays',
        actionUrl:       '/holiday',
      ),
      const Ad(
        id:              'ad_003',
        tagline:         'Your Routine,\nYour Rules.',
        caption:         'Manage your daily schedule with precision.',
        backgroundAsset: 'assets/logo/A24.png',
        buttonLabel:     'See Routine',
        actionUrl:       '/routine',
      ),
    ];

    state = AdsLoaded(mockAds);
  }

  /// Refresh ads list.
  Future<void> refresh() => loadAds();
}
