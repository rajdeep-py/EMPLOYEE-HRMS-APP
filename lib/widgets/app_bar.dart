// ============================================================
//  app_bar.dart — AttendX24 Premium App Bar
//
//  Usage:
//    AppBar: appBar: AttendX24AppBar(title: 'Dashboard')
//    SliverAppBar: use AttendX24AppBar.asSliverAppBar(...)
//
//  Logic:
//   • If showLogo=true  → shows A24.png logo + title + subtitle
//   • If showLogo=false → shows a back-chevron instead of the logo
//   • Notification bell icon always on the right (badge count optional)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_theme.dart';

class AttendX24AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Primary title text (bold, dark).
  final String title;

  /// Optional subtitle / screen description below the title.
  final String? subtitle;

  /// When true the A24.png logo is shown instead of a back-chevron.
  final bool showLogo;

  /// Unread notification count. 0 = no badge.
  final int notificationCount;

  /// Callback for the notification icon tap.
  final VoidCallback? onNotificationTap;

  /// Extra trailing actions to the right of the notification icon.
  final List<Widget> extraActions;

  const AttendX24AppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.extraActions = const [],
  });

  // ─────────────────────────────────────────────
  //  PreferredSizeWidget
  // ─────────────────────────────────────────────
  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle != null ? 68 : 56);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
        ),
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.grey100, width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading: logo or back button ───────────────
              _buildLeading(context),

              const SizedBox(width: AppSpacing.sm),

              // ── Title + subtitle ────────────────────────────
              Expanded(child: _buildTitleBlock()),

              // ── Notification icon ───────────────────────────
              _buildNotificationIcon(),

              // ── Extra actions ───────────────────────────────
              ...extraActions,
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Leading widget
  // ─────────────────────────────────────────────
  Widget _buildLeading(BuildContext context) {
    if (showLogo) {
      return Image.asset(
        'assets/logo/A24.png',
        width:  36,
        height: 36,
        filterQuality: FilterQuality.high,
      );
    }

    // Back button
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width:  36,
        height: 36,
        decoration: BoxDecoration(
          color:        AppColors.grey100,
          borderRadius: AppRadius.mdAll,
        ),
        child: Icon(
          Iconsax.arrow_left_2,
          size:  18,
          color: AppColors.darkBase,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Title block
  // ─────────────────────────────────────────────
  Widget _buildTitleBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headerSmall.copyWith(
            color: AppColors.darkBase,
            fontVariations: const [FontVariation('wght', 700)],
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 1),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Notification bell
  // ─────────────────────────────────────────────
  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: onNotificationTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color:        AppColors.grey100,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(
              Iconsax.notification,
              size:  20,
              color: AppColors.darkBase,
            ),
          ),
          // Badge
          if (notificationCount > 0)
            Positioned(
              top:   -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  notificationCount > 99 ? '99+' : '$notificationCount',
                  style: AppTextStyles.captionSmall.copyWith(
                    color:    AppColors.white,
                    fontSize: 8,
                    fontVariations: const [FontVariation('wght', 700)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
