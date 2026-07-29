import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/damage_reports/models/damage_report.dart';
import 'package:inspection_app/features/damage_reports/services/damage_report_service.dart';

/// Family provider — one instance per inspectionId.
final damageReportsProvider =
    AsyncNotifierProvider.family<DamageReportsNotifier, List<DamageReport>, int>(
        DamageReportsNotifier.new);

class DamageReportsNotifier extends FamilyAsyncNotifier<List<DamageReport>, int> {
  @override
  Future<List<DamageReport>> build(int arg) =>
      ref.read(damageReportServiceProvider).getByInspection(arg);

  Future<void> add(Map<String, dynamic> body) async {
    final r = await ref.read(damageReportServiceProvider).create(body);
    state = AsyncData([...?state.valueOrNull, r]);
  }

  Future<void> remove(int id) async {
    await ref.read(damageReportServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((d) => d.id != id).toList() ?? []);
  }
}
