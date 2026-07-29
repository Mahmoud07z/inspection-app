import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/locations/models/location.dart';
import 'package:inspection_app/features/locations/services/location_service.dart';

/// Family provider — one instance per warehouseId.
final locationsProvider =
    AsyncNotifierProvider.family<LocationsNotifier, List<Location>, int>(
        LocationsNotifier.new);

class LocationsNotifier extends FamilyAsyncNotifier<List<Location>, int> {
  @override
  Future<List<Location>> build(int arg) =>
      ref.read(locationServiceProvider).getByWarehouse(arg);

  Future<void> add(Map<String, dynamic> body) async {
    final l = await ref.read(locationServiceProvider).create(body);
    state = AsyncData([...?state.valueOrNull, l]);
  }

  Future<void> remove(int id) async {
    await ref.read(locationServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((l) => l.id != id).toList() ?? []);
  }
}
