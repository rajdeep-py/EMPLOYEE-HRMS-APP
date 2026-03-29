import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../notifiers/auth_notifier.dart';
import '../../routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass = true;

  late final AnimationController _enterCtrl;
  late final Animation<double> _enterFade;
  late final Animation<Offset> _enterSlide;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _enterFade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthAuthenticated) context.go(AppRoutes.home);
      if (next is AuthError) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            AppSnackBar.error(
              next.message,
              actionLabel: 'Dismiss',
              onAction: () =>
                  ref.read(authNotifierProvider.notifier).resetError(),
            ),
          );
      }
    });

    final isLoading = ref.watch(isAuthLoadingProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        body: SafeArea(
          child: FadeTransition(
            opacity: _enterFade,
            child: SlideTransition(
              position: _enterSlide,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding(context),
                  vertical: AppSpacing.md,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildForm(isLoading),
                        const SizedBox(height: AppSpacing.lg),
                        _buildTroubleText(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildDivider(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildAdminLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Header
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portal chip badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: AppRadius.pillAll,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            'EMPLOYEE PORTAL',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.primary,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Welcome Back 👋',
          style: AppTextStyles.headerXL.copyWith(color: AppColors.darkBase),
        ),
        const SizedBox(height: AppSpacing.sm),

        Text(
          'Sign in to continue your attendance journey.',
          style: AppTextStyles.taglineMedium.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Form
  // ─────────────────────────────────────────────
  Widget _buildForm(bool isLoading) {
    InputDecoration lightBorder(
      String hint, {
      required Widget prefix,
      Widget? suffix,
    }) => InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      hintText: hint,
      counterText: '',
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: prefix,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 56),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 56),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.lgAll,
        borderSide: BorderSide(color: AppColors.grey200, width: 1.5),
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
      border: OutlineInputBorder(
        borderRadius: AppRadius.lgAll,
        borderSide: BorderSide(color: AppColors.grey200, width: 1.5),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Phone
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: lightBorder(
              '+91 Phone Number',
              prefix: Icon(
                Iconsax.call,
                color: AppColors.primaryDark,
                size: 20,
              ),
            ),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkBase),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Phone number is required';
              }
              if (v.trim().length < 10) {
                return 'Enter a valid 10-digit number';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Password
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePass,
            decoration: lightBorder(
              'Password',
              prefix: Icon(
                Iconsax.lock,
                color: AppColors.primaryDark,
                size: 20,
              ),
              suffix: GestureDetector(
                onTap: () => setState(() => _obscurePass = !_obscurePass),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    _obscurePass ? Iconsax.eye_slash : Iconsax.eye,
                    color: AppColors.grey400,
                    size: 20,
                  ),
                ),
              ),
            ),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkBase),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Password is required';
              }
              if (v.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Sign In button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: AppButtonStyles.primaryFilled,
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Having trouble? Contact Support
  // ─────────────────────────────────────────────
  Widget _buildTroubleText() {
    return Center(
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(AppSnackBar.info('Support: support@attendx24.com')),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Having trouble signing in? ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              TextSpan(
                text: 'Contact Support!',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontVariations: const [FontVariation('wght', 600)],
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Divider
  // ─────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'OR',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.grey400,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Login as Admin
  // ─────────────────────────────────────────────
  Widget _buildAdminLogin() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Iconsax.briefcase,
                  size: 15,
                  color: AppColors.grey500,
                ),
              ),
            ),
            TextSpan(
              text: 'Login as ',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
            TextSpan(
              text: 'Admin',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontVariations: const [FontVariation('wght', 600)],
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Submit
  // ─────────────────────────────────────────────
  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref
        .read(authNotifierProvider.notifier)
        .login(
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
  }
}
