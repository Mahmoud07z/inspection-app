import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/core/theme/theme_mode_provider.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';

const _drawerBackground = Color(0xFF10202C);
const _drawerAccent = Color(0xFF9DE4D7);

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = GoRouterState.of(context).matchedLocation;
    const items = [
      (Icons.dashboard_outlined, 'Overview', RouteNames.dashboard),
      (Icons.warehouse_outlined, 'Warehouses', RouteNames.warehouses),
      (Icons.location_on_outlined, 'Locations', RouteNames.locations),
      (Icons.inventory_2_outlined, 'Articles', RouteNames.articles),
      (Icons.fact_check_outlined, 'Inspections', RouteNames.inspections),
      (
        Icons.report_gmailerrorred_outlined,
        'Damage reports',
        RouteNames.damageReports,
      ),
      (Icons.people_outline_rounded, 'Team members', RouteNames.users),
    ];

    return Drawer(
      width: 304,
      backgroundColor: _drawerBackground,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _DrawerHeader(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 9),
              child: Text(
                'WORKSPACE',
                style: TextStyle(
                  color: Color(0xFF91A8B6),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.25,
                ),
              ),
            ),
            for (final (icon, label, route) in items)
              _NavigationItem(
                icon: icon,
                label: label,
                selected:
                    current == route ||
                    (route != RouteNames.dashboard &&
                        current.startsWith('$route/')),
                onTap: () {
                  Navigator.pop(context);
                  context.go(route);
                },
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 12),
              child: Divider(color: Color(0xFF344956), height: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A303D),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2A424F)),
                ),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  secondary: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: _drawerAccent,
                  ),
                  title: const Text(
                    'Dark appearance',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    isDark ? 'On' : 'Off',
                    style: const TextStyle(
                      color: Color(0xFFAABBC5),
                      fontSize: 12,
                    ),
                  ),
                  value:
                      themeMode == ThemeMode.system
                          ? isDark
                          : themeMode == ThemeMode.dark,
                  activeThumbColor: _drawerAccent,
                  activeTrackColor: const Color(0xFF39766E),
                  onChanged:
                      (enabled) => ref
                          .read(themeModeProvider.notifier)
                          .setMode(enabled ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed:
                    () => ref
                        .read(themeModeProvider.notifier)
                        .setMode(ThemeMode.system),
                icon: const Icon(Icons.settings_suggest_outlined, size: 16),
                label: const Text('Use device setting'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB6C6CF),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 4, 18, 10),
              child: Divider(color: Color(0xFF344956), height: 1),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFFB4AB),
              ),
              title: const Text(
                'Sign out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => ref.read(authProvider.notifier).logout(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) => Container(
    height: 154,
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF17364A), Color(0xFF1C5660)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Color(0x339DE4D7),
          child: Icon(Icons.fact_check_outlined, color: _drawerAccent),
        ),
        SizedBox(height: 12),
        Text(
          'Inspection App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'WAREHOUSE OPERATIONS',
          style: TextStyle(
            color: Color(0xFFB8D2D6),
            fontSize: 9,
            letterSpacing: 1.1,
          ),
        ),
      ],
    ),
  );
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    child: ListTile(
      dense: true,
      selected: selected,
      selectedTileColor: const Color(0xFF254553),
      selectedColor: _drawerAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(
        icon,
        color: selected ? _drawerAccent : const Color(0xFFB6C6CF),
        size: 21,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFFE1E8EC),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    ),
  );
}
