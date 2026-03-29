// ============================================================
//  main.dart — App Entry Point
//  ProviderScope + MaterialApp.router + AppTheme.dark + GoRouter
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AttendX24App(),
    ),
  );
}

class AttendX24App extends ConsumerWidget {
  const AttendX24App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title:            'AttendX24',
      debugShowCheckedModeBanner: false,
      theme:            AppTheme.dark,
      routerConfig:     router,
    );
  }
}
