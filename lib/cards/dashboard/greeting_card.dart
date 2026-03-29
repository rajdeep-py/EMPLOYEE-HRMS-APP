// ============================================================
//  greeting_card.dart — Time-aware Greeting Card
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class GreetingCard extends ConsumerWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user        = ref.watch(currentUserProvider);
    final firstName   = user?.name.split(' ').first ?? 'there';
    final now         = DateTime.now();
    final greeting    = _greeting(now.hour);
    final emoji       = _emoji(now.hour);
    final dateString  = _formatDate(now);

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: AppRadius.lgAll,
        border:       Border.all(color: AppColors.grey100, width: 1),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Text block ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting line
                Row(
                  children: [
                    Text(
                      greeting,
                      style: AppTextStyles.headerSmall.copyWith(
                        color:          AppColors.darkBase,
                        fontVariations: const [FontVariation('wght', 700)],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 2),

                // Employee name
                Text(
                  firstName,
                  style: AppTextStyles.headerMedium.copyWith(
                    color:          AppColors.primary,
                    fontVariations: const [FontVariation('wght', 800)],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size:  13,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      dateString,
                      style: AppTextStyles.captionMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Time chip ──────────────────────────────────────
          _LiveClock(),
        ],
      ),
    );
  }

  String _greeting(int hour) {
    if (hour >= 5 && hour < 12)  return 'Good Morning,';
    if (hour >= 12 && hour < 17) return 'Good Afternoon,';
    if (hour >= 17 && hour < 21) return 'Good Evening,';
    return 'Good Night,';
  }

  String _emoji(int hour) {
    if (hour >= 5  && hour < 12) return '☀️';
    if (hour >= 12 && hour < 17) return '🌤️';
    if (hour >= 17 && hour < 21) return '🌆';
    return '🌙';
  }

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month]} ${dt.year}';
  }
}

// ─────────────────────────────────────────────
//  Live clock widget (updates every second)
// ─────────────────────────────────────────────
class _LiveClock extends StatefulWidget {
  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      _tick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final m    = _now.minute.toString().padLeft(2, '0');
    final s   = _now.second.toString().padLeft(2, '0');
    final ampm = _now.hour >= 12 ? 'PM' : 'AM';
    final h12 = (_now.hour % 12 == 0 ? 12 : _now.hour % 12)
        .toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:        AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$h12:$m',
                  style: AppTextStyles.headerSmall.copyWith(
                    color:          AppColors.primary,
                    fontVariations: const [FontVariation('wght', 700)],
                    fontSize:       22,
                  ),
                ),
                TextSpan(
                  text: ':$s',
                  style: AppTextStyles.captionLarge.copyWith(
                    color: AppColors.primary.withValues(alpha: 0.70),
                    fontVariations: const [FontVariation('wght', 500)],
                  ),
                ),
              ],
            ),
          ),
          Text(
            ampm,
            style: AppTextStyles.captionSmall.copyWith(
              color:          AppColors.primary,
              fontVariations: const [FontVariation('wght', 600)],
            ),
          ),
        ],
      ),
    );
  }
}
