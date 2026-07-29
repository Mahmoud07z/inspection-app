import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/features/warehouses/widgets/warehouse_card.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

class WarehousesScreen extends ConsumerWidget {
  const WarehousesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(warehousesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Warehouses')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(message: e.toString(), onRetry: () => ref.invalidate(warehousesProvider)),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No warehouses found'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => WarehouseCard(
                  warehouse: list[i],
                  onTap: () => context.go('/warehouses/${list[i].id}'),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create warehouse form */},
        child: const Icon(Icons.add),
      ),
    );
  }
}
