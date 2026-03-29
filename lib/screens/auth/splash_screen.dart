// ============================================================
//  splash_screen.dart — Cinematic Animated Splash
//  Logo: assets/logo/A24.png — slides in from RIGHT → CENTER
//  Title "AttendX24"         — slides in from LEFT  → CENTER
//  Total on-screen time: ~2.5 seconds
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Logo animation ──────────────────────────
  late final AnimationController _logoCtrl;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoFade;

  // ── Title animation ─────────────────────────
  late final AnimationController _titleCtrl;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  // ── Glow pulse animation ─────────────────────
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowScale;

  @override
  void initState() {
    super.initState();

    // ── Logo: slides from far right (x=3) → center (x=0) ───────────────
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(3.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutExpo));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // ── Title: slides from far left (x=-3) → center (x=0) ──────────────
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(-3.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOutExpo));
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // ── Background glow pulse ────────────────────────────────────────────
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowScale = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Step 1: Logo slides in from right (750ms)
    await _logoCtrl.forward();

    // Step 2: Brief pause after logo settles (200ms)
    await Future.delayed(const Duration(milliseconds: 200));

    // Step 3: Title slides in from left (650ms)
    await _titleCtrl.forward();

    // Step 4: Both visible — cinematic hold (850ms)
    await Future.delayed(const Duration(milliseconds: 850));

    // Step 5: Navigate to login
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _titleCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // ── Radial glow behind logo ────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _glowScale,
              builder: (context, child) => Transform.scale(
                scale: _glowScale.value,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.10),
                        AppColors.primary.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Main content — logo + title ────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo — slides in from RIGHT
                ClipRect(
                  child: SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        'assets/logo/A24.png',
                        width: 200,
                        height: 200,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // "AttendX24" — slides in from LEFT
                ClipRect(
                  child: SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleFade,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Attend',
                              style: AppTextStyles.headerLarge.copyWith(
                                color: AppColors.darkBase,
                                fontSize: 34,
                                fontVariations: const [
                                  FontVariation('wght', 700),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: 'X',
                              style: AppTextStyles.headerLarge.copyWith(
                                color: AppColors.primary,
                                fontSize: 34,
                                fontVariations: const [
                                  FontVariation('wght', 800),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: '24',
                              style: AppTextStyles.headerLarge.copyWith(
                                color: AppColors.darkBase,
                                fontSize: 34,
                                fontVariations: const [
                                  FontVariation('wght', 700),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
