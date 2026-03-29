// ============================================================
//  dashboard_screen.dart — Main Dashboard after Login
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/ads_carousels.dart';
import '../../cards/dashboard/greeting_card.dart';
import '../../cards/dashboard/check_in_out_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _navIndex = NavIndex.dashboard;

  @override
  void initState() {
    super.initState();
    // Load today's attendance record
    Future.microtask(() {
      final userId = ref.read(currentUserProvider)?.id ?? '';
      ref.read(dashboardNotifierProvider.notifier).loadTodayRecord(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AttendX24AppBar(
        title: 'AttendX24',
        subtitle: _subtitle(),
        showLogo: true,
        notificationCount: 0,
        onNotificationTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(AppSnackBar.info('Notifications coming soon!')),
      ),
      body: _buildBody(),
      bottomNavigationBar: AttendX24BottomNavBar(
        currentIndex: _navIndex,
        onIndexChanged: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _buildBody() {
    // Non-dashboard tabs — swap with real screens later
    if (_navIndex != NavIndex.dashboard) {
      return AttendX24BottomNavBar.screenForIndex(_navIndex);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final userId = ref.read(currentUserProvider)?.id ?? '';
        await ref
            .read(dashboardNotifierProvider.notifier)
            .loadTodayRecord(userId);
      },
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding(context),
          vertical: AppSpacing.md,
        ),
        children: const [
          // ── Greeting ─────────────────────────────────────
          GreetingCard(),

          SizedBox(height: AppSpacing.md),

          // ── Check In / Out ────────────────────────────────
          CheckInOutCard(),

          SizedBox(height: AppSpacing.md),

          // ── Announcements carousel ───────────────────────
          _SectionHeader(title: 'Announcements'),

          SizedBox(height: AppSpacing.sm),

          AdsCarousel(),

          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  String _subtitle() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return 'Good Morning ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon 🌤️';
    if (hour >= 17 && hour < 21) return 'Good Evening 🌆';
    return 'Good Night 🌙';
  }
}

// ─────────────────────────────────────────────
//  Section header helper
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.taglineMedium.copyWith(
        color: AppColors.darkBase,
        fontVariations: const [FontVariation('wght', 600)],
      ),
    );
  }
}
