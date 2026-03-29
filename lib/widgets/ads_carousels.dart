// ============================================================
//  ads_carousels.dart — Auto-swiping Ads Carousel Widget
//
//  Features:
//   • Loads ads via Riverpod (adsNotifierProvider)
//   • Auto-advances every 3 seconds with smooth horizontal animation
//   • Each card: background asset image, gradient overlay,
//     tagline, caption, "Explore Now" button
//   • Dot page indicators below the card
//   • Manual swipe supported (PageView)
//   • Skeleton shimmer while loading
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ads.dart';
import '../notifiers/ads_notifier.dart';
import '../providers/ads_provider.dart';
import '../theme/app_theme.dart';

class AdsCarousel extends ConsumerStatefulWidget {
  /// Called when the user taps "Explore Now". Receives the ad's [actionUrl].
  final void Function(String? actionUrl)? onExplore;

  const AdsCarousel({super.key, this.onExplore});

  @override
  ConsumerState<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends ConsumerState<AdsCarousel> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    // Load ads on first mount
    Future.microtask(() => ref.read(adsNotifierProvider.notifier).loadAds());
  }

  // ── Auto-advance timer ─────────────────────────────────────
  void _startTimer(int count) {
    _autoTimer?.cancel();
    if (count <= 1) return;
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % count;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(adsNotifierProvider);
    final isLoading = ref.watch(adsLoadingProvider);
    final adsList = ref.watch(adsListProvider);

    // Start/restart timer whenever ads load
    if (adsState is AdsLoaded && adsList.isNotEmpty) {
      _startTimer(adsList.length);
    }

    if (isLoading || adsState is AdsInitial) {
      return _buildSkeleton();
    }

    if (adsState is AdsError) {
      return _buildError(adsState.message);
    }

    if (adsList.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── PageView carousel ──────────────────────────────────
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: adsList.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) =>
                _AdCard(ad: adsList[index], onExplore: widget.onExplore),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // ── Dot indicators ─────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(adsList.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.grey300,
                borderRadius: AppRadius.pillAll,
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Loading skeleton ─────────────────────────────────────
  Widget _buildSkeleton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: AppRadius.xlAll,
          ),
          child: _ShimmerBox(height: 180, borderRadius: AppRadius.xlAll),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == 0 ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: AppRadius.pillAll,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Error state ───────────────────────────────────────────
  Widget _buildError(String message) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: AppRadius.xlAll,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: AppColors.grey400, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Could not load announcements',
              style: AppTextStyles.captionLarge.copyWith(
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              style: AppButtonStyles.ghost,
              onPressed: () => ref.read(adsNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Individual Ad Card
// ─────────────────────────────────────────────
class _AdCard extends StatelessWidget {
  final Ad ad;
  final void Function(String? actionUrl)? onExplore;

  const _AdCard({required this.ad, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        borderRadius: AppRadius.xlAll,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background asset image ────────────────────────
            _buildBackground(),

            // ── Dark gradient overlay ─────────────────────────
            _buildGradient(),

            // ── Content ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tagline
                  Text(
                    ad.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headerSmall.copyWith(
                      color: AppColors.white,
                      fontVariations: const [FontVariation('wght', 700)],
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Caption
                  Text(
                    ad.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionLarge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.80),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Explore Now button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.darkBase,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.pillAll,
                        ),
                        textStyle: AppTextStyles.buttonSmall.copyWith(
                          fontVariations: const [FontVariation('wght', 600)],
                        ),
                      ),
                      onPressed: () => onExplore?.call(ad.actionUrl),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ad.buttonLabel),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final asset = ad.backgroundAsset;
    final isPng =
        asset.endsWith('.png') ||
        asset.endsWith('.jpg') ||
        asset.endsWith('.jpeg') ||
        asset.endsWith('.webp');

    if (isPng) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stack) => _fallbackBg(),
      );
    }
    return _fallbackBg();
  }

  Widget _fallbackBg() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 1.0],
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.25),
            Colors.black.withValues(alpha: 0.72),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shimmer skeleton box
// ─────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerBox({required this.height, required this.borderRadius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: false);
    _anim = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => ClipRRect(
        borderRadius: widget.borderRadius,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end: Alignment(_anim.value + 1, 0),
              colors: [AppColors.grey200, AppColors.grey100, AppColors.grey200],
            ),
          ),
        ),
      ),
    );
  }
}
