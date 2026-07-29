import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/features/auth/screens/login_screen.dart';
import 'package:inspection_app/features/articles/screens/articles_screen.dart';
import 'package:inspection_app/features/damage_reports/screens/damage_reports_screen.dart';
import 'package:inspection_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:inspection_app/features/inspections/screens/inspection_detail_screen.dart';
import 'package:inspection_app/features/inspections/screens/inspections_screen.dart';
import 'package:inspection_app/features/locations/screens/locations_screen.dart';
import 'package:inspection_app/features/users/screens/users_screen.dart';
import 'package:inspection_app/features/warehouses/screens/warehouse_detail_screen.dart';
import 'package:inspection_app/features/warehouses/screens/warehouses_screen.dart';

/// Bridges Riverpod auth state to GoRouter's refreshListenable.
/// When auth changes, GoRouter re-evaluates [redirect] without rebuilding
/// the entire router tree.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(authProvider, (_, __) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.dashboard,
    debugLogDiagnostics: true,
    refreshListenable: _RouterRefresh(ref),
    redirect: (_, state) {
      final auth = ref.read(authProvider);
      if (auth.isLoading) return null;
      final loggedIn  = auth.valueOrNull?.token != null;
      final onLogin   = state.matchedLocation == RouteNames.login;
      if (!loggedIn && !onLogin) return RouteNames.login;
      if (loggedIn  &&  onLogin) return RouteNames.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: RouteNames.login,     builder: (_, __) => const LoginScreen()),
      GoRoute(path: RouteNames.dashboard, builder: (_, __) => const DashboardScreen()),
      GoRoute(
        path: RouteNames.warehouses,
        builder: (_, __) => const WarehousesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => WarehouseDetailScreen(id: int.parse(s.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(path: RouteNames.locations,     builder: (_, __) => const LocationsScreen()),
      GoRoute(path: RouteNames.articles,      builder: (_, __) => const ArticlesScreen()),
      GoRoute(
        path: RouteNames.inspections,
        builder: (_, __) => const InspectionsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => InspectionDetailScreen(id: int.parse(s.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(path: RouteNames.damageReports, builder: (_, __) => const DamageReportsScreen()),
      GoRoute(path: RouteNames.users,         builder: (_, __) => const UsersScreen()),
    ],
  );
});
