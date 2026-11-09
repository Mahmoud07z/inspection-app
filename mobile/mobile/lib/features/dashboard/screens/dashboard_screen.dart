import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/core/theme/app_colors.dart';
import 'package:inspection_app/features/articles/providers/articles_provider.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/features/dashboard/widgets/stat_card.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/widgets/inspection_card.dart';
import 'package:inspection_app/features/locations/providers/locations_provider.dart';
import 'package:inspection_app/features/users/providers/users_provider.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final warehouseState = ref.watch(warehousesProvider);
    final articleState = ref.watch(articlesProvider);
    final inspectionState = ref.watch(inspectionsProvider);
    final userState = ref.watch(usersProvider);

    final warehouses = warehouseState.valueOrNull ?? const [];
    final articles = articleState.valueOrNull ?? const [];
    final inspections = inspectionState.valueOrNull ?? const <Inspection>[];
    final users = userState.valueOrNull ?? const [];
    final locationStates = [
      for (final warehouse in warehouses)
        ref.watch(locationsProvider(warehouse.id)),
    ];
    final locationsReady = !warehouseState.isLoading &&
        !warehouseState.hasError &&
        locationStates.every((state) => state.hasValue && !state.isLoading);
    final locationCount = locationsReady
        ? locationStates.fold<int>(
            0,
            (total, state) => total + (state.valueOrNull?.length ?? 0),
          )
        : null;
    final damageCount = inspections.fold<int>(
      0,
      (total, inspection) => total + inspection.damageReportCount,
    );
    final hasLoadError = [
      warehouseState.hasError,
      articleState.hasError,
      inspectionState.hasError,
      userState.hasError,
      locationStates.any((state) => state.hasError),
    ].any((hasError) => hasError);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            tooltip: 'Refresh overview',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                _refresh(ref, warehouses.map((warehouse) => warehouse.id)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1120
              ? 5
              : constraints.maxWidth >= 720
                  ? 3
                  : 2;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WelcomeBanner(
                      username: user?.username ?? 'there',
                      onCreateInspection: () =>
                          context.go(RouteNames.inspections),
                    ),
                    if (hasLoadError) ...[
                      const SizedBox(height: 16),
                      _LoadError(
                          onRetry: () => _refresh(ref,
                              warehouses.map((warehouse) => warehouse.id))),
                    ],
                    const SizedBox(height: 28),
                    const _SectionHeading(
                      title: 'Operations at a glance',
                      subtitle: 'A live view of your inspection workspace',
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: columns == 2 ? 1.75 : 1.48,
                      children: [
                        StatCard(
                          label: 'Warehouses',
                          count: _count(warehouseState, warehouses.length),
                          icon: Icons.warehouse_outlined,
                          tint: const Color(0xFFEAF1FF),
                          onTap: () => context.go(RouteNames.warehouses),
                        ),
                        StatCard(
                          label: 'Locations',
                          count: locationCount,
                          icon: Icons.location_on_outlined,
                          tint: const Color(0xFFE7F7F5),
                          onTap: () => context.go(RouteNames.locations),
                        ),
                        StatCard(
                          label: 'Inspections',
                          count: _count(inspectionState, inspections.length),
                          icon: Icons.fact_check_outlined,
                          tint: const Color(0xFFFFF4E6),
                          onTap: () => context.go(RouteNames.inspections),
                        ),
                        StatCard(
                          label: 'Articles',
                          count: _count(articleState, articles.length),
                          icon: Icons.inventory_2_outlined,
                          tint: const Color(0xFFF1ECFF),
                          onTap: () => context.go(RouteNames.articles),
                        ),
                        StatCard(
                          label: 'Damage reports',
                          count: inspectionState.hasError ||
                                  inspectionState.isLoading
                              ? null
                              : damageCount,
                          icon: Icons.report_gmailerrorred_outlined,
                          tint: const Color(0xFFFFECEB),
                          onTap: () => context.go(RouteNames.damageReports),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const _SectionHeading(
                      title: 'Quick access',
                      subtitle: 'Jump straight into the work you need to do',
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _QuickAction(
                          icon: Icons.add_task_rounded,
                          label: 'Plan inspection',
                          onTap: () => context.go(RouteNames.inspections),
                        ),
                        _QuickAction(
                          icon: Icons.add_business_outlined,
                          label: 'Manage warehouses',
                          onTap: () => context.go(RouteNames.warehouses),
                        ),
                        _QuickAction(
                          icon: Icons.inventory_2_outlined,
                          label: 'Browse articles',
                          onTap: () => context.go(RouteNames.articles),
                        ),
                        _QuickAction(
                          icon: Icons.people_outline_rounded,
                          label:
                              'Team members · ${userState.isLoading || userState.hasError ? '—' : users.length}',
                          onTap: () => context.go(RouteNames.users),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _SectionHeading(
                      title: 'Recent inspections',
                      subtitle: inspections.isEmpty
                          ? 'Your latest activity will appear here'
                          : 'Track schedules, progress and findings',
                      trailing: TextButton.icon(
                        onPressed: () => context.go(RouteNames.inspections),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('View all'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (inspectionState.isLoading && inspections.isEmpty)
                      const _DashboardPlaceholder(
                          message: 'Loading inspections…')
                    else if (inspectionState.hasError && inspections.isEmpty)
                      const _DashboardPlaceholder(
                          message: 'Inspections are temporarily unavailable.')
                    else if (inspections.isEmpty)
                      _DashboardPlaceholder(
                        message:
                            'No inspections yet. Plan your first inspection to get started.',
                        action: FilledButton.icon(
                          onPressed: () => context.go(RouteNames.inspections),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Create inspection'),
                        ),
                      )
                    else
                      ..._recent(inspections).map(
                        (inspection) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InspectionCard(
                            inspection: inspection,
                            onTap: () => context.go(
                              '${RouteNames.inspections}/${inspection.id}',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static int? _count(AsyncValue<dynamic> state, int value) =>
      state.isLoading || state.hasError ? null : value;

  static List<Inspection> _recent(List<Inspection> inspections) {
    final recent = [...inspections]
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    return recent.take(4).toList();
  }

  static void _refresh(WidgetRef ref, Iterable<int> warehouseIds) {
    ref.invalidate(warehousesProvider);
    ref.invalidate(articlesProvider);
    ref.invalidate(inspectionsProvider);
    ref.invalidate(usersProvider);
    for (final warehouseId in warehouseIds) {
      ref.invalidate(locationsProvider(warehouseId));
    }
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner(
      {required this.username, required this.onCreateInspection});

  final String username;
  final VoidCallback onCreateInspection;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF10263D), Color(0xFF1B4965)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x2010263D),
                blurRadius: 24,
                offset: Offset(0, 10)),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 560;
            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'INSPECTION WORKSPACE',
                    style: TextStyle(
                      color: Color(0xFF9DE4D7),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome back, $username',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Keep your warehouses organized and every inspection moving.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .76),
                        height: 1.45,
                      ),
                ),
                if (compact) ...[
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onCreateInspection,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Plan an inspection'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9DE4D7),
                      foregroundColor: const Color(0xFF10263D),
                    ),
                  ),
                ],
              ],
            );
            if (compact) return content;
            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 20),
                FilledButton.icon(
                  onPressed: onCreateInspection,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Plan an inspection'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF9DE4D7),
                    foregroundColor: const Color(0xFF10263D),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(
      {required this.title, required this.subtitle, this.trailing});

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        backgroundColor: scheme.surface,
      ),
    );
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.fact_check_outlined,
              size: 32, color: scheme.onSurfaceVariant),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.wifi_off_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 19),
              const SizedBox(width: 10),
              const Expanded(
                  child: Text('Some workspace data could not be loaded.')),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
}
