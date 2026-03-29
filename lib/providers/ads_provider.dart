// ============================================================
//  ads_provider.dart — Riverpod Providers for Ads
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ads.dart';
import '../notifiers/ads_notifier.dart';

/// Primary ads notifier provider.
final adsNotifierProvider =
    StateNotifierProvider<AdsNotifier, AdsState>((ref) {
  return AdsNotifier();
});

/// Derived: the list of ads when loaded (empty list otherwise).
final adsListProvider = Provider<List<Ad>>((ref) {
  final state = ref.watch(adsNotifierProvider);
  return state is AdsLoaded ? state.ads : [];
});

/// Derived: true while ads are loading.
final adsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(adsNotifierProvider) is AdsLoading;
});

/// Derived: error message (null if none).
final adsErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(adsNotifierProvider);
  return state is AdsError ? state.message : null;
});
