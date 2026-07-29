import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/navigation/app_router.dart';
import 'package:inspection_app/core/theme/app_theme.dart';

/// Root widget. [ConsumerWidget] lets us watch [appRouterProvider] so the
/// auth-guard redirect fires immediately on login / logout without a rebuild.
class InspectionApp extends ConsumerWidget {
  const InspectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Inspection App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
