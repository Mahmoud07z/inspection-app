import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/navigation/app_router.dart';
import 'package:inspection_app/core/theme/app_theme.dart';

<<<<<<< HEAD
/// Root widget. [ConsumerWidget] lets us watch [appRouterProvider] so the
/// auth-guard redirect fires immediately on login / logout without a rebuild.
=======
/// Root widget of the application.
///
/// [ConsumerWidget] allows reading Riverpod providers at the top level.
/// The [appRouterProvider] is watched so the router's redirect guard reacts
/// immediately whenever authentication state changes (login / logout).
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
class InspectionApp extends ConsumerWidget {
  const InspectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< HEAD
=======
    final router = ref.watch(appRouterProvider);

>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    return MaterialApp.router(
      title: 'Inspection App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
<<<<<<< HEAD
      routerConfig: ref.watch(appRouterProvider),
=======
      routerConfig: router,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    );
  }
}
