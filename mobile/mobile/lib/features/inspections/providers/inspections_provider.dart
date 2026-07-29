import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/features/inspections/services/inspection_service.dart';

final inspectionsProvider =
    AsyncNotifierProvider<InspectionsNotifier, List<Inspection>>(InspectionsNotifier.new);

class InspectionsNotifier extends AsyncNotifier<List<Inspection>> {
  String? _statusFilter;

  @override
  Future<List<Inspection>> build() => ref.read(inspectionServiceProvider).getAll();

  Future<void> filter({int? warehouseId, int? inspectorId, String? status}) async {
    _statusFilter = status;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(inspectionServiceProvider)
        .getAll(warehouseId: warehouseId, inspectorId: inspectorId, status: status));
  }

  Future<void> transitionStatus(int id, String status) async {
    final updated = await ref.read(inspectionServiceProvider).updateStatus(id, status);
    state = AsyncData(
        state.valueOrNull?.map((i) => i.id == id ? updated : i).toList() ?? [updated]);
  }

  Future<void> remove(int id) async {
    await ref.read(inspectionServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((i) => i.id != id).toList() ?? []);
  }
}

/// Single-item provider for detail screen.
final inspectionDetailProvider = FutureProvider.family<Inspection, int>(
  (ref, id) => ref.read(inspectionServiceProvider).getById(id),
);
