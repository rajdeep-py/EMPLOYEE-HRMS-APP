// ============================================================
//  app_theme.dart — HRMS Employee App
//  Premium, modern theme system
//  Font: BricolageGrotesque
//  Palette: #0B1216 · #12A30D · #079C10 · Grey · White · Error Red
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  1. COLOR PALETTE
// ─────────────────────────────────────────────
abstract final class AppColors {
  // Brand
  static const Color darkBase    = Color(0xFF0B1216); // deep dark background
  static const Color primary     = Color(0xFF12A30D); // primary green
  static const Color primaryDark = Color(0xFF079C10); // darker green (hover/pressed)

  // Neutrals
  static const Color white       = Color(0xFFFFFFFF);
  static const Color grey50      = Color(0xFFF8F9FA);
  static const Color grey100     = Color(0xFFF1F3F5);
  static const Color grey200     = Color(0xFFE9ECEF);
  static const Color grey300     = Color(0xFFDEE2E6);
  static const Color grey400     = Color(0xFFCED4DA);
  static const Color grey500     = Color(0xFFADB5BD);
  static const Color grey600     = Color(0xFF6C757D);
  static const Color grey700     = Color(0xFF495057);
  static const Color grey800     = Color(0xFF343A40);
  static const Color grey900     = Color(0xFF212529);

  // Semantic
  static const Color error       = Color(0xFFE53935); // error red
  static const Color errorLight  = Color(0xFFFFEBEE);
  static const Color success     = Color(0xFF12A30D);
  static const Color successLight= Color(0xFFE8F5E9);
  static const Color warning     = Color(0xFFFFA000);
  static const Color warningLight= Color(0xFFFFF8E1);
  static const Color info        = Color(0xFF1E88E5);
  static const Color infoLight   = Color(0xFFE3F2FD);

  // Surface / Card backgrounds
  static const Color surfaceDark  = Color(0xFF131D22); // cards on dark bg
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color overlayDark  = Color(0x99000000); // 60% black

  // Divider
  static const Color dividerDark  = Color(0xFF1E2D34);
  static const Color dividerLight = Color(0xFFE0E0E0);
}

// ─────────────────────────────────────────────
//  2. RESPONSIVE BREAKPOINTS
// ─────────────────────────────────────────────

/// Breakpoints (logical pixels)
///   mobile        < 600
///   tablet        600 – 1024
///   desktopSmall  1024 – 1280  (minimised / narrow desktop)
///   desktopLarge  ≥ 1280
abstract final class AppBreakpoints {
  static const double mobile        = 600;
  static const double tablet        = 1024;
  static const double desktopSmall  = 1280;

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < mobile;

  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= mobile && w < tablet;
  }

  static bool isDesktopSmall(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= tablet && w < desktopSmall;
  }

  static bool isDesktopLarge(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= desktopSmall;

  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= tablet;
}

// ─────────────────────────────────────────────
//  3. SPACING SCALE
// ─────────────────────────────────────────────
abstract final class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
  static const double hg  = 64;

  /// Returns horizontal page padding based on screen size.
  static double pagePadding(BuildContext ctx) {
    if (AppBreakpoints.isDesktopLarge(ctx)) return 120;
    if (AppBreakpoints.isDesktopSmall(ctx)) return 64;
    if (AppBreakpoints.isTablet(ctx))       return 40;
    return 20;
  }

  /// Returns content max-width for constrained layouts.
  static double maxContentWidth(BuildContext ctx) {
    if (AppBreakpoints.isDesktopLarge(ctx)) return 1200;
    if (AppBreakpoints.isDesktopSmall(ctx)) return 960;
    if (AppBreakpoints.isTablet(ctx))       return 720;
    return double.infinity;
  }
}

// ─────────────────────────────────────────────
//  4. TYPOGRAPHY
//     Font: BricolageGrotesque
// ─────────────────────────────────────────────
abstract final class AppTextStyles {
  static const String _font = 'BricolageGrotesque';

  // ── Display / Hero ──────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _font,
    fontSize: 57,
    fontVariations: [FontVariation('wght', 800)],
    letterSpacing: -1.5,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _font,
    fontSize: 45,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: -1.0,
    height: 1.16,
  );

  // ── Headers ─────────────────────────────────
  /// Page / Section main heading  (h1)
  static const TextStyle headerXL = TextStyle(
    fontFamily: _font,
    fontSize: 36,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Card / Modal heading  (h2)
  static const TextStyle headerLarge = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: -0.3,
    height: 1.25,
  );

  /// Sub-section heading  (h3)
  static const TextStyle headerMedium = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: -0.2,
    height: 1.3,
  );

  /// Small heading / label header  (h4)
  static const TextStyle headerSmall = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0,
    height: 1.35,
  );

  // ── Tagline / Subtitle ───────────────────────
  static const TextStyle taglineLarge = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle taglineMedium = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle taglineSmall = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.1,
    height: 1.5,
  );

  // ── Body / Description ───────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.5,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.25,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.4,
    height: 1.6,
  );

  // ── Caption ──────────────────────────────────
  static const TextStyle captionLarge = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0.4,
    height: 1.4,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.6,
    height: 1.4,
  );

  // ── Overline / Label ─────────────────────────
  static const TextStyle overline = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 1.5,
    height: 1.4,
  );

  // ── Button Labels ─────────────────────────────
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0.5,
    height: 1.0,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0.4,
    height: 1.0,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0.3,
    height: 1.0,
  );
}

// ─────────────────────────────────────────────
//  5. BORDER RADIUS
// ─────────────────────────────────────────────
abstract final class AppRadius {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 28;
  static const double pill = 100;

  static BorderRadius get xsAll  => BorderRadius.circular(xs);
  static BorderRadius get smAll  => BorderRadius.circular(sm);
  static BorderRadius get mdAll  => BorderRadius.circular(md);
  static BorderRadius get lgAll  => BorderRadius.circular(lg);
  static BorderRadius get xlAll  => BorderRadius.circular(xl);
  static BorderRadius get xxlAll => BorderRadius.circular(xxl);
  static BorderRadius get pillAll => BorderRadius.circular(pill);
}

// ─────────────────────────────────────────────
//  6. SHADOWS
// ─────────────────────────────────────────────
abstract final class AppShadows {
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.18),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get primaryGlow => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────
//  7. BUTTON STYLES
// ─────────────────────────────────────────────
abstract final class AppButtonStyles {
  // ── Primary Filled ───────────────────────────
  static ButtonStyle get primaryFilled => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    disabledBackgroundColor: AppColors.grey400,
    disabledForegroundColor: AppColors.grey600,
    elevation: 0,
    shadowColor: Colors.transparent,
    minimumSize: const Size(120, 52),
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
    textStyle: AppTextStyles.buttonLarge,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primaryDark.withValues(alpha: 0.2);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.white.withValues(alpha: 0.08);
      }
      return null;
    }),
    elevation: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.hovered) ? 4 : 0),
    shadowColor: WidgetStateProperty.all(
      AppColors.primary.withValues(alpha: 0.4),
    ),
  );

  // ── Primary Outlined ─────────────────────────
  static ButtonStyle get primaryOutlined => OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    disabledForegroundColor: AppColors.grey500,
    side: const BorderSide(color: AppColors.primary, width: 1.5),
    minimumSize: const Size(120, 52),
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
    textStyle: AppTextStyles.buttonLarge,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primary.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.primary.withValues(alpha: 0.06);
      }
      return null;
    }),
  );

  // ── Ghost / Text Button ───────────────────────
  static ButtonStyle get ghost => TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    minimumSize: const Size(80, 44),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    textStyle: AppTextStyles.buttonMedium,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primary.withValues(alpha: 0.14);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.primary.withValues(alpha: 0.07);
      }
      return null;
    }),
  );

  // ── Danger / Destructive ─────────────────────
  static ButtonStyle get danger => ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.white,
    elevation: 0,
    minimumSize: const Size(120, 52),
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
    textStyle: AppTextStyles.buttonLarge,
  );

  // ── Small Chip-button ─────────────────────────
  static ButtonStyle get chip => ElevatedButton.styleFrom(
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.grey300,
    elevation: 0,
    minimumSize: const Size(64, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
    textStyle: AppTextStyles.buttonSmall,
  );
}

// ─────────────────────────────────────────────
//  8. INPUT DECORATION THEME
// ─────────────────────────────────────────────
abstract final class AppInputTheme {
  static InputDecorationTheme get dark => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: AppColors.dividerDark, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: AppColors.dividerDark, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
    labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
    floatingLabelStyle: AppTextStyles.captionLarge.copyWith(color: AppColors.primary),
    errorStyle: AppTextStyles.captionMedium.copyWith(color: AppColors.error),
    prefixIconColor: AppColors.grey500,
    suffixIconColor: AppColors.grey500,
  );
}

// ─────────────────────────────────────────────
//  9. SNACKBAR HELPERS
// ─────────────────────────────────────────────
abstract final class AppSnackBar {
  // Generic factory
  static SnackBar _build({
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      backgroundColor: background,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      elevation: 6,
      content: Row(
        children: [
          Icon(icon, color: foreground, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: foreground),
            ),
          ),
        ],
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              textColor: foreground,
              onPressed: onAction,
            )
          : null,
    );
  }

  static SnackBar success(String message, {String? actionLabel, VoidCallback? onAction}) =>
      _build(
        message: message,
        background: AppColors.primaryDark,
        foreground: AppColors.white,
        icon: Icons.check_circle_outline_rounded,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static SnackBar error(String message, {String? actionLabel, VoidCallback? onAction}) =>
      _build(
        message: message,
        background: AppColors.error,
        foreground: AppColors.white,
        icon: Icons.error_outline_rounded,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: const Duration(seconds: 5),
      );

  static SnackBar warning(String message, {String? actionLabel, VoidCallback? onAction}) =>
      _build(
        message: message,
        background: AppColors.warning,
        foreground: AppColors.darkBase,
        icon: Icons.warning_amber_rounded,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static SnackBar info(String message, {String? actionLabel, VoidCallback? onAction}) =>
      _build(
        message: message,
        background: AppColors.info,
        foreground: AppColors.white,
        icon: Icons.info_outline_rounded,
        actionLabel: actionLabel,
        onAction: onAction,
      );
}

// ─────────────────────────────────────────────
//  10. DIALOG HELPERS
// ─────────────────────────────────────────────
abstract final class AppDialogs {
  /// Premium confirmation dialog.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.overlayDark,
      builder: (_) => _AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDangerous: isDangerous,
      ),
    );
  }

  /// Premium info / alert dialog.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String closeLabel = 'Got it',
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.overlayDark,
      builder: (_) => _AppAlertDialog(
        title: title,
        message: message,
        closeLabel: closeLabel,
      ),
    );
  }
}

class _AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDangerous;

  const _AppConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDangerous,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.headerSmall.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: AppButtonStyles.ghost,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelLabel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    style: isDangerous
                        ? AppButtonStyles.danger
                        : AppButtonStyles.primaryFilled,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String closeLabel;

  const _AppAlertDialog({
    required this.title,
    required this.message,
    required this.closeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.headerSmall.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: AppButtonStyles.primaryFilled,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(closeLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  11. RESPONSIVE LAYOUT HELPER WIDGET
// ─────────────────────────────────────────────

/// Wraps a child in a centered, max-width–constrained, horizontally padded
/// box that adapts to all screen sizes automatically.
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final bool centerContent;

  const ResponsivePage({
    super.key,
    required this.child,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.pagePadding(context);
    final maxWidth = AppSpacing.maxContentWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: centerContent ? Center(child: child) : child,
        ),
      ),
    );
  }
}

/// Adaptive columns builder.
///   mobile → 1 col | tablet → 2 cols | desktop → [desktopCols] cols
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int tabletCols;
  final int desktopCols;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.tabletCols  = 2,
    this.desktopCols = 3,
    this.spacing     = AppSpacing.md,
    this.runSpacing  = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    final cols = AppBreakpoints.isDesktop(context)
        ? desktopCols
        : AppBreakpoints.isTablet(context)
            ? tabletCols
            : 1;

    return LayoutBuilder(
      builder: (_, constraints) {
        final cellWidth =
            (constraints.maxWidth - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: cellWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  12. MAIN ThemeData
// ─────────────────────────────────────────────
abstract final class AppTheme {
  static ThemeData get dark => _buildDark();

  static ThemeData _buildDark() {
    const colorScheme = ColorScheme.dark(
      primary:          AppColors.primary,
      onPrimary:        AppColors.white,
      primaryContainer: AppColors.primaryDark,
      secondary:        AppColors.primaryDark,
      onSecondary:      AppColors.white,
      surface:          AppColors.surfaceDark,
      onSurface:        AppColors.white,
      error:            AppColors.error,
      onError:          AppColors.white,
      outline:          AppColors.dividerDark,
      shadow:           Colors.black,
      scrim:            Colors.black,
      inverseSurface:   AppColors.white,
      onInverseSurface: AppColors.darkBase,
    );

    return ThemeData(
      useMaterial3:  true,
      colorScheme:   colorScheme,
      scaffoldBackgroundColor: AppColors.darkBase,
      fontFamily:    'BricolageGrotesque',

      // ── AppBar ────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  AppColors.darkBase,
        foregroundColor:  AppColors.white,
        elevation:        0,
        scrolledUnderElevation: 1,
        shadowColor:      Colors.black.withValues(alpha: 0.3),
        centerTitle:      false,
        titleTextStyle:   AppTextStyles.headerSmall.copyWith(
          color: AppColors.white,
        ),
        iconTheme:        const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
      ),

      // ── Card ─────────────────────────────────
      cardTheme: CardThemeData(
        color:     AppColors.surfaceDark,
        elevation: 0,
        margin:    EdgeInsets.zero,
        shape:     RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: AppColors.dividerDark, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ── ElevatedButton ────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primaryFilled,
      ),

      // ── OutlinedButton ────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.primaryOutlined,
      ),

      // ── TextButton ────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.ghost,
      ),

      // ── InputDecoration ───────────────────────
      inputDecorationTheme: AppInputTheme.dark,

      // ── Snackbar ──────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior:         SnackBarBehavior.floating,
        backgroundColor:  AppColors.surfaceDark,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        elevation: 6,
      ),

      // ── Dialog ────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor:  AppColors.surfaceDark,
        elevation:        0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: AppTextStyles.headerSmall.copyWith(
          color: AppColors.white,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey400,
        ),
        barrierColor: AppColors.overlayDark,
      ),

      // ── BottomSheet ───────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:     AppColors.surfaceDark,
        elevation:           0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        dragHandleColor: AppColors.grey600,
        showDragHandle:  true,
      ),

      // ── Divider ───────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     AppColors.dividerDark,
        thickness: 1,
        space:     1,
      ),

      // ── ListTile ──────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor:       Colors.transparent,
        textColor:       AppColors.white,
        iconColor:       AppColors.grey400,
        contentPadding:  const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical:   AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),

      // ── Chip ─────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:    AppColors.surfaceDark,
        selectedColor:      AppColors.primary,
        disabledColor:      AppColors.grey800,
        labelStyle:         AppTextStyles.captionLarge.copyWith(
          color: AppColors.grey300,
        ),
        secondaryLabelStyle: AppTextStyles.captionLarge.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.pillAll,
          side: BorderSide(color: AppColors.dividerDark),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // ── NavigationBar ─────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:         AppColors.surfaceDark,
        indicatorColor:          AppColors.primary.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.grey500, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.captionLarge.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.captionLarge.copyWith(color: AppColors.grey500);
        }),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),

      // ── NavigationRail (Desktop sidebar) ──────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor:    AppColors.surfaceDark,
        selectedIconTheme:  const IconThemeData(color: AppColors.primary),
        unselectedIconTheme:const IconThemeData(color: AppColors.grey500),
        selectedLabelTextStyle: AppTextStyles.captionLarge.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: AppTextStyles.captionLarge.copyWith(
          color: AppColors.grey500,
        ),
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        elevation: 0,
        groupAlignment: -1,
        labelType: NavigationRailLabelType.selected,
      ),

      // ── Switch / Checkbox / Radio ─────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.grey500),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.grey700),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : Colors.transparent),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.grey500, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xsAll),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.grey500),
      ),

      // ── Progress / Circular Indicator ─────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:            AppColors.primary,
        linearTrackColor: AppColors.dividerDark,
        circularTrackColor: AppColors.dividerDark,
      ),

      // ── Tooltip ───────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.grey800,
          borderRadius: AppRadius.smAll,
        ),
        textStyle: AppTextStyles.captionMedium.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ── FloatingActionButton ──────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        hoverElevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        extendedTextStyle: AppTextStyles.buttonMedium,
      ),

      // ── TabBar ────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:         AppColors.primary,
        unselectedLabelColor: AppColors.grey500,
        labelStyle:         AppTextStyles.buttonMedium,
        unselectedLabelStyle: AppTextStyles.buttonMedium,
        indicatorColor:     AppColors.primary,
        indicatorSize:      TabBarIndicatorSize.tab,
        dividerColor:       AppColors.dividerDark,
      ),

      // ── PopupMenu ─────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color:    AppColors.surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: AppColors.dividerDark),
        ),
        textStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
      ),

      // ── Text ──────────────────────────────────
      textTheme: TextTheme(
        displayLarge:  AppTextStyles.displayLarge.copyWith(color: AppColors.white),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.white),
        displaySmall:  AppTextStyles.headerXL.copyWith(color: AppColors.white),
        headlineLarge: AppTextStyles.headerLarge.copyWith(color: AppColors.white),
        headlineMedium:AppTextStyles.headerMedium.copyWith(color: AppColors.white),
        headlineSmall: AppTextStyles.headerSmall.copyWith(color: AppColors.white),
        titleLarge:    AppTextStyles.taglineLarge.copyWith(color: AppColors.white),
        titleMedium:   AppTextStyles.taglineMedium.copyWith(color: AppColors.grey300),
        titleSmall:    AppTextStyles.taglineSmall.copyWith(color: AppColors.grey400),
        bodyLarge:     AppTextStyles.bodyLarge.copyWith(color: AppColors.grey200),
        bodyMedium:    AppTextStyles.bodyMedium.copyWith(color: AppColors.grey300),
        bodySmall:     AppTextStyles.bodySmall.copyWith(color: AppColors.grey400),
        labelLarge:    AppTextStyles.buttonLarge.copyWith(color: AppColors.white),
        labelMedium:   AppTextStyles.captionLarge.copyWith(color: AppColors.grey300),
        labelSmall:    AppTextStyles.captionSmall.copyWith(color: AppColors.grey500),
      ),
    );
  }
}
