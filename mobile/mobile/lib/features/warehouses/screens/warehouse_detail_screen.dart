import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/utils/date_formatter.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/core/navigation/route_names.dart';

class WarehouseDetailScreen extends ConsumerWidget {
  const WarehouseDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to warehouses',
          onPressed: () => context.go(RouteNames.warehouses),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Warehouse Detail'),
      ),
      body: ref.watch(warehouseDetailProvider(id)).when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorDisplay(message: e.toString()),
            data: (w) => _Detail(w: w),
          ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.w});
  final Warehouse w;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Row('Code', w.code),
        _Row('Name', w.name),
        _Row('Address', w.address ?? '—'),
        _Row('Created', DateFormatter.display(w.createdAt)),
        _Row('Updated', DateFormatter.display(w.updatedAt)),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => context.go('/locations?warehouseId=${w.id}'),
          icon: const Icon(Icons.location_on_outlined),
          label: const Text('View locations'),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 90,
                child: Text(label,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500))),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
