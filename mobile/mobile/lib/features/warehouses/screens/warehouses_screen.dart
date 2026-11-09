import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/features/warehouses/widgets/warehouse_card.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';

class WarehousesScreen extends ConsumerWidget {
  const WarehousesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(warehousesProvider);
    return Scaffold(
      appBar: WorkspaceAppBar(
        title: 'Warehouses',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search warehouses',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onChanged: (query) =>
                  ref.read(warehousesProvider.notifier).search(query),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(
            message: e.toString(),
            onRetry: () => ref.invalidate(warehousesProvider)),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No warehouses found'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final warehouse = list[i];
                  return WarehouseCard(
                    warehouse: warehouse,
                    onTap: () => context.go('/warehouses/${warehouse.id}'),
                    onEdit: () => _editWarehouse(context, ref, warehouse),
                    onDelete: () => _deleteWarehouse(context, ref, warehouse),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editWarehouse(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Warehouse'),
      ),
    );
  }
}

Future<void> _editWarehouse(
    BuildContext context, WidgetRef ref, Warehouse? warehouse) async {
  final code = TextEditingController(text: warehouse?.code ?? '');
  final name = TextEditingController(text: warehouse?.name ?? '');
  final address = TextEditingController(text: warehouse?.address ?? '');
  await showAppFormDialog(
    context: context,
    title: warehouse == null ? 'New warehouse' : 'Edit warehouse',
    fields: [
      TextFormField(
        controller: code,
        enabled: warehouse == null,
        decoration: const InputDecoration(labelText: 'Warehouse code'),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a code' : null,
      ),
      TextFormField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a name' : null,
      ),
      TextFormField(
          controller: address,
          decoration: const InputDecoration(labelText: 'Address')),
    ],
    onSave: () => warehouse == null
        ? ref.read(warehousesProvider.notifier).add({
            'code': code.text.trim(),
            'name': name.text.trim(),
            'address': address.text.trim().isEmpty ? null : address.text.trim(),
          })
        : ref.read(warehousesProvider.notifier).updateItem(warehouse.id, {
            'name': name.text.trim(),
            'address': address.text.trim().isEmpty ? null : address.text.trim(),
          }),
  );
  code.dispose();
  name.dispose();
  address.dispose();
}

Future<void> _deleteWarehouse(
    BuildContext context, WidgetRef ref, Warehouse warehouse) async {
  if (!await confirmDelete(context, warehouse.name)) return;
  try {
    await ref.read(warehousesProvider.notifier).remove(warehouse.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
