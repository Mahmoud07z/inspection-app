import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/navigation/app_router.dart';
import 'package:inspection_app/core/theme/app_theme.dart';

/// Root widget of the application.
///
/// [ConsumerWidget] allows reading Riverpod providers at the top level.
/// The [appRouterProvider] is watched so the router's redirect guard reacts
/// immediately whenever authentication state changes (login / logout).
class InspectionApp extends ConsumerWidget {
  const InspectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Inspection App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
