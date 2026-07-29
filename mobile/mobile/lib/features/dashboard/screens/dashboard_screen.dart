import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/features/dashboard/widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      drawer: _NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null && user.username.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text('Welcome, ${user.username}',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            Text('Overview',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                StatCard(label: 'Warehouses',     icon: Icons.warehouse,       onTap: () => context.go(RouteNames.warehouses)),
                StatCard(label: 'Inspections',    icon: Icons.checklist,       onTap: () => context.go(RouteNames.inspections)),
                StatCard(label: 'Articles',       icon: Icons.inventory_2,     onTap: () => context.go(RouteNames.articles)),
                StatCard(label: 'Damage Reports', icon: Icons.report_problem,  onTap: () => context.go(RouteNames.damageReports)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      (Icons.dashboard,      'Dashboard',      RouteNames.dashboard),
      (Icons.warehouse,      'Warehouses',     RouteNames.warehouses),
      (Icons.location_on,    'Locations',      RouteNames.locations),
      (Icons.inventory_2,    'Articles',       RouteNames.articles),
      (Icons.checklist,      'Inspections',    RouteNames.inspections),
      (Icons.report_problem, 'Damage Reports', RouteNames.damageReports),
      (Icons.people,         'Users',          RouteNames.users),
    ];

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1565C0)),
            child: Text('Inspection App',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          for (final (icon, label, route) in items)
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              onTap: () { Navigator.pop(context); context.go(route); },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
