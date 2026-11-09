import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/locations/providers/locations_provider.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/features/locations/widgets/location_tile.dart';
import 'package:inspection_app/features/locations/models/location.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';
import 'package:inspection_app/shared/widgets/qr_scanner_dialog.dart';

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key, this.warehouseId});
  final int? warehouseId;

  @override
  ConsumerState<LocationsScreen> createState() => _State();
}

class _State extends ConsumerState<LocationsScreen> {
  int? _selectedWarehouseId;
  String? _scannedLocationCode;

  @override
  Widget build(BuildContext context) {
    final warehouses = ref.watch(warehousesProvider);
    final availableWarehouses = warehouses.valueOrNull ?? [];
    final requestedId = _selectedWarehouseId ?? widget.warehouseId;
    final selectedWarehouseId =
        availableWarehouses.isEmpty
            ? null
            : availableWarehouses.any((w) => w.id == requestedId)
            ? requestedId
            : availableWarehouses.first.id;
    return Scaffold(
      appBar: WorkspaceAppBar(
        title: 'Locations',
        actions: [
          IconButton(
            tooltip: 'Scan location QR code',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: _scanLocationCode,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: warehouses.when(
        loading: () => const LoadingIndicator(),
        error:
            (e, _) => ErrorDisplay(
              message: e.toString(),
              onRetry: () => ref.invalidate(warehousesProvider),
            ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Add a warehouse to view its locations'),
            );
          }
          final selectedId = selectedWarehouseId!;
          final state = ref.watch(locationsProvider(selectedId));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: DropdownButtonFormField<int>(
                  initialValue:
                      items.any((w) => w.id == selectedId)
                          ? selectedId
                          : items.first.id,
                  decoration: const InputDecoration(labelText: 'Warehouse'),
                  items: [
                    for (final warehouse in items)
                      DropdownMenuItem(
                        value: warehouse.id,
                        child: Text('${warehouse.code} · ${warehouse.name}'),
                      ),
                  ],
                  onChanged:
                      (id) => setState(() {
                        _selectedWarehouseId = id;
                        _scannedLocationCode = null;
                      }),
                ),
              ),
              Expanded(
                child: state.when(
                  loading: () => const LoadingIndicator(),
                  error:
                      (e, _) => ErrorDisplay(
                        message: e.toString(),
                        onRetry:
                            () => ref.invalidate(locationsProvider(selectedId)),
                      ),
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(child: Text('No locations found'));
                    }
                    final visible =
                        _scannedLocationCode == null
                            ? list
                            : list
                                .where(
                                  (location) =>
                                      location.code.toLowerCase() ==
                                      _scannedLocationCode!.toLowerCase(),
                                )
                                .toList();
                    if (visible.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'No location matches "$_scannedLocationCode".',
                            ),
                            TextButton(
                              onPressed:
                                  () => setState(
                                    () => _scannedLocationCode = null,
                                  ),
                              child: const Text('Clear scan'),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (_, i) {
                        final location = visible[i];
                        return LocationTile(
                          location: location,
                          onEdit:
                              () => _editLocation(
                                context,
                                ref,
                                selectedId,
                                location,
                              ),
                          onDelete:
                              () => _deleteLocation(
                                context,
                                ref,
                                selectedId,
                                location,
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton:
          selectedWarehouseId == null
              ? null
              : FloatingActionButton.extended(
                onPressed:
                    () =>
                        _editLocation(context, ref, selectedWarehouseId, null),
                icon: const Icon(Icons.add),
                label: const Text('Location'),
              ),
    );
  }

  Future<void> _scanLocationCode() async {
    final code = await scanQrCode(context);
    if (!mounted || code == null) return;
    final warehouses = ref.read(warehousesProvider).valueOrNull ?? const [];
    final requestedId = _selectedWarehouseId ?? widget.warehouseId;
    final selectedId =
        warehouses.any((warehouse) => warehouse.id == requestedId)
            ? requestedId
            : warehouses.firstOrNull?.id;
    if (selectedId == null) return;

    try {
      final locations = await ref.read(locationsProvider(selectedId).future);
      if (!mounted) return;
      setState(() => _scannedLocationCode = code);
      final found = locations.any(
        (location) => location.code.toLowerCase() == code.toLowerCase(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            found
                ? 'Location found: $code'
                : 'No location matches QR code "$code" in this warehouse.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

Future<void> _editLocation(
  BuildContext context,
  WidgetRef ref,
  int warehouseId,
  Location? location,
) async {
  final code = TextEditingController(text: location?.code ?? '');
  final description = TextEditingController(text: location?.description ?? '');
  await showAppFormDialog(
    context: context,
    title: location == null ? 'New location' : 'Edit location',
    fields: [
      TextFormField(
        controller: code,
        enabled: location == null,
        decoration: const InputDecoration(labelText: 'Location code'),
        validator:
            (value) =>
                value == null || value.trim().isEmpty ? 'Enter a code' : null,
      ),
      TextFormField(
        controller: description,
        decoration: const InputDecoration(labelText: 'Description'),
      ),
    ],
    onSave:
        () =>
            location == null
                ? ref.read(locationsProvider(warehouseId).notifier).add({
                  'code': code.text.trim(),
                  'description':
                      description.text.trim().isEmpty
                          ? null
                          : description.text.trim(),
                  'warehouseId': warehouseId,
                })
                : ref
                    .read(locationsProvider(warehouseId).notifier)
                    .updateItem(location.id, {
                      'description':
                          description.text.trim().isEmpty
                              ? null
                              : description.text.trim(),
                    }),
  );
  code.dispose();
  description.dispose();
}

Future<void> _deleteLocation(
  BuildContext context,
  WidgetRef ref,
  int warehouseId,
  Location location,
) async {
  if (!await confirmDelete(context, location.code)) return;
  try {
    await ref.read(locationsProvider(warehouseId).notifier).remove(location.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
