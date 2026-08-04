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

/// Bridges Riverpod's [authProvider] async state to GoRouter's
/// [refreshListenable] mechanism.
///
/// When the auth state changes (login / logout), [notifyListeners] fires
/// and GoRouter re-evaluates the [redirect] callback on the next frame —
/// without rebuilding the entire router tree.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
}

/// Riverpod provider that exposes the [GoRouter] singleton to [InspectionApp].
///
/// The router is **not** recreated on auth changes; instead the
/// [_RouterRefreshNotifier] triggers a lightweight redirect re-evaluation.
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RouteNames.dashboard,
    debugLogDiagnostics: true,
    refreshListenable: notifier,

    /// Authentication guard.
    /// - Unauthenticated users trying to access any protected route → /login.
    /// - Authenticated users trying to visit /login → /.
    /// - Still loading persisted token → no redirect (show current screen).
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      if (authState.isLoading) return null; // token restore in progress

      final isLoggedIn  = authState.valueOrNull?.token != null;
      final isOnLogin   = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isOnLogin) return RouteNames.login;
      if (isLoggedIn  &&  isOnLogin) return RouteNames.dashboard;
      return null;
    },

    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.warehouses,
        builder: (_, __) => const WarehousesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => WarehouseDetailScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.locations,
        builder: (_, __) => const LocationsScreen(),
      ),
      GoRoute(
        path: RouteNames.articles,
        builder: (_, __) => const ArticlesScreen(),
      ),
      GoRoute(
        path: RouteNames.inspections,
        builder: (_, __) => const InspectionsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => InspectionDetailScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
            routes: [
              GoRoute(
                path: 'damage-reports',
                builder: (_, state) => DamageReportsScreen(
                  inspectionId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.damageReports,
        builder: (_, state) {
          final idStr = state.uri.queryParameters['inspectionId'];
          return DamageReportsScreen(inspectionId: idStr != null ? int.parse(idStr) : 0);
        },
      ),
      GoRoute(
        path: RouteNames.users,
        builder: (_, __) => const UsersScreen(),
      ),
    ],
  );
});
