// ============================================================
//  check_in_out_card.dart — Check-In / Check-Out Card
//  Captures selfie (front camera) + current location on action.
// ============================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../models/attendance.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';

class CheckInOutCard extends ConsumerWidget {
  const CheckInOutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state        = ref.watch(dashboardNotifierProvider);
    final status       = state.status;
    final record       = state.todayRecord;
    final isCheckingIn = state.isCheckingIn;
    final isCheckingOut= state.isCheckingOut;
    final user         = ref.watch(currentUserProvider);
    final isBusy       = isCheckingIn || isCheckingOut;

    // Show error snackbar
    ref.listen(dashboardErrorProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            AppSnackBar.error(
              next,
              actionLabel: 'OK',
              onAction: () =>
                  ref.read(dashboardNotifierProvider.notifier).clearError(),
            ),
          );
      }
    });

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:        _statusColor(status).withValues(alpha: 0.12),
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(
                  _statusIcon(status),
                  size:  18,
                  color: _statusColor(status),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Attendance',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    Text(
                      _statusLabel(status),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color:          _statusColor(status),
                        fontVariations: const [FontVariation('wght', 600)],
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:        _statusColor(status).withValues(alpha: 0.10),
                  borderRadius: AppRadius.pillAll,
                  border:       Border.all(
                    color: _statusColor(status).withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  _statusLabel(status).toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color:    _statusColor(status),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.grey100, height: 1),
          const SizedBox(height: AppSpacing.md),

          // ── Check-in / Check-out times ──────────────────────
          Row(
            children: [
              Expanded(
                child: _TimeSlot(
                  label:    'Check In',
                  time:     record?.checkInTime,
                  icon:     Iconsax.login,
                  iconColor: AppColors.primary,
                ),
              ),
              Container(
                width:  1,
                height: 40,
                color:  AppColors.grey100,
              ),
              Expanded(
                child: _TimeSlot(
                  label:    'Check Out',
                  time:     record?.checkOutTime,
                  icon:     Iconsax.logout,
                  iconColor: AppColors.error,
                ),
              ),
            ],
          ),

          // ── Location row (if checked in) ────────────────────
          if (record?.checkInAddress != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Iconsax.location, size: 13, color: AppColors.grey500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    record!.checkInAddress!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── Selfie preview when checked in ──────────────────
          if (record?.checkInPhotoPath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Iconsax.camera, size: 13, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(
                  'Selfie captured',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: Image.file(
                    File(record!.checkInPhotoPath!),
                    width:  36,
                    height: 36,
                    fit:    BoxFit.cover,
                    errorBuilder: (c, e, s) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // ── Action button ───────────────────────────────────
          SizedBox(
            width:  double.infinity,
            height: 50,
            child: ElevatedButton(
              style: status == AttendanceStatus.checkedIn
                  ? AppButtonStyles.danger
                  : AppButtonStyles.primaryFilled,
              onPressed: isBusy
                  ? null
                  : () => _handleAction(context, ref, status, user?.id ?? ''),
              child: isBusy
                  ? SizedBox(
                      width:  20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          status == AttendanceStatus.checkedIn
                              ? Iconsax.logout
                              : Iconsax.login,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          status == AttendanceStatus.checkedIn
                              ? 'Check Out'
                              : 'Check In',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Note
          Center(
            child: Text(
              status == AttendanceStatus.checkedIn
                  ? 'A selfie and your location will be captured on check-out.'
                  : 'A selfie and your location will be captured on check-in.',
              textAlign: TextAlign.center,
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    AttendanceStatus status,
    String employeeId,
  ) {
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    if (status == AttendanceStatus.checkedIn) {
      notifier.checkOut(employeeId);
    } else {
      notifier.checkIn(employeeId);
    }
  }

  Color _statusColor(AttendanceStatus s) {
    return switch (s) {
      AttendanceStatus.checkedIn  => AppColors.primary,
      AttendanceStatus.checkedOut => AppColors.grey600,
      AttendanceStatus.onBreak    => AppColors.warning,
    };
  }

  IconData _statusIcon(AttendanceStatus s) {
    return switch (s) {
      AttendanceStatus.checkedIn  => Iconsax.tick_circle,
      AttendanceStatus.checkedOut => Iconsax.close_circle,
      AttendanceStatus.onBreak    => Iconsax.pause_circle,
    };
  }

  String _statusLabel(AttendanceStatus s) {
    return switch (s) {
      AttendanceStatus.checkedIn  => 'Checked In',
      AttendanceStatus.checkedOut => 'Not Checked In',
      AttendanceStatus.onBreak    => 'On Break',
    };
  }
}

// ─────────────────────────────────────────────
//  Time slot sub-widget
// ─────────────────────────────────────────────
class _TimeSlot extends StatelessWidget {
  final String   label;
  final DateTime? time;
  final IconData icon;
  final Color    iconColor;

  const _TimeSlot({
    required this.label,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = time != null ? _fmt(time!) : '--:--';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.captionSmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 2),
          Text(
            formatted,
            style: AppTextStyles.bodyMedium.copyWith(
              color:          AppColors.darkBase,
              fontVariations: const [FontVariation('wght', 600)],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final h    = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString().padLeft(2, '0');
    final m    = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
