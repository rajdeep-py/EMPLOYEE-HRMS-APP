// ============================================================
//  bottom_nav_bar.dart — AttendX24 Bottom Navigation Bar
//
//  Tabs (in order):
//    0 — Dashboard    Iconsax.home / home_2 (filled)
//    1 — Attendance   Iconsax.calendar_tick / calendar_tick (filled)
//    2 — Holiday      Iconsax.sun / sun (filled)
//    3 — Routine      Iconsax.clock / clock (filled)
//    4 — Profile      Iconsax.user / user (filled)
//
//  Usage:
//    Pass [currentIndex] and [onIndexChanged] from the parent
//    shell/scaffold. Use the static [screenForIndex] method to
//    resolve which body widget to render.
// ============================================================

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
//  Tab model
// ─────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;

  const _NavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(
    label:        'Dashboard',
    activeIcon:   Iconsax.home_2,   // filled variant
    inactiveIcon: Iconsax.home_1,
  ),
  _NavItem(
    label:        'Attendance',
    activeIcon:   Iconsax.calendar_tick,
    inactiveIcon: Iconsax.calendar,
  ),
  _NavItem(
    label:        'Holiday',
    activeIcon:   Iconsax.sun_1,    // filled variant
    inactiveIcon: Iconsax.sun,
  ),
  _NavItem(
    label:        'Routine',
    activeIcon:   Iconsax.timer_1,  // filled variant
    inactiveIcon: Iconsax.timer,
  ),
  _NavItem(
    label:        'Profile',
    activeIcon:   Iconsax.user,     // filled variant
    inactiveIcon: Iconsax.user_octagon,
  ),
];

// ─────────────────────────────────────────────
//  Screen-index constants (use in switch-case)
// ─────────────────────────────────────────────
abstract final class NavIndex {
  static const int dashboard  = 0;
  static const int attendance = 1;
  static const int holiday    = 2;
  static const int routine    = 3;
  static const int profile    = 4;
}

// ─────────────────────────────────────────────
//  AttendX24BottomNavBar widget
// ─────────────────────────────────────────────
class AttendX24BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const AttendX24BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.grey100, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              return Expanded(
                child: _NavTile(
                  item:      _navItems[index],
                  isActive:  index == currentIndex,
                  onTap:     () => onIndexChanged(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Resolve which widget body to show based on [index].
  /// Wire this up in your shell scaffold's body.
  ///
  /// Example:
  /// ```dart
  /// body: AttendX24BottomNavBar.screenForIndex(_currentIndex),
  /// ```
  static Widget screenForIndex(int index) {
    switch (index) {
      case NavIndex.dashboard:
        return const _PlaceholderScreen(label: '📊 Dashboard');
      case NavIndex.attendance:
        return const _PlaceholderScreen(label: '📅 Attendance');
      case NavIndex.holiday:
        return const _PlaceholderScreen(label: '🌴 Holiday');
      case NavIndex.routine:
        return const _PlaceholderScreen(label: '⏱ Routine');
      case NavIndex.profile:
        return const _PlaceholderScreen(label: '👤 Profile');
      default:
        return const _PlaceholderScreen(label: '📊 Dashboard');
    }
  }
}

// ─────────────────────────────────────────────
//  Individual nav tile
// ─────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.grey400;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animated green pill background when active
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: AppRadius.pillAll,
              ),
              child: Icon(
                isActive ? item.activeIcon : item.inactiveIcon,
                size:  22,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.captionSmall.copyWith(
                color: color,
                fontVariations: [
                  FontVariation('wght', isActive ? 600 : 400),
                ],
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Placeholder screen stub (replace per tab)
// ─────────────────────────────────────────────
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
