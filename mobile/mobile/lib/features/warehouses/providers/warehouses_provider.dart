import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';
import 'package:inspection_app/features/warehouses/services/warehouse_service.dart';

final warehousesProvider =
    AsyncNotifierProvider<WarehousesNotifier, List<Warehouse>>(WarehousesNotifier.new);

class WarehousesNotifier extends AsyncNotifier<List<Warehouse>> {
  @override
  Future<List<Warehouse>> build() => ref.read(warehouseServiceProvider).getAll();

  Future<void> search(String? name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(warehouseServiceProvider).getAll(name: name?.isEmpty == true ? null : name));
  }

  Future<void> add(Map<String, dynamic> body) async {
    final w = await ref.read(warehouseServiceProvider).create(body);
    state = AsyncData([...?state.valueOrNull, w]);
  }

  Future<void> remove(int id) async {
    await ref.read(warehouseServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((w) => w.id != id).toList() ?? []);
  }
}

/// Per-warehouse detail provider (FutureProvider.family scoped to a single id).
final warehouseDetailProvider = FutureProvider.family<Warehouse, int>(
  (ref, id) => ref.read(warehouseServiceProvider).getById(id),
);
