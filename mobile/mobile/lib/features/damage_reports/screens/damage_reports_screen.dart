import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/damage_reports/providers/damage_reports_provider.dart';
import 'package:inspection_app/features/damage_reports/widgets/damage_report_tile.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

class DamageReportsScreen extends ConsumerWidget {
  const DamageReportsScreen({super.key, required this.inspectionId});
  final int inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(damageReportsProvider(inspectionId));
    return Scaffold(
      appBar: AppBar(title: const Text('Damage Reports')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(
            message: e.toString(),
            onRetry: () => ref.invalidate(damageReportsProvider(inspectionId))),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No damage reports for this inspection'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => DamageReportTile(report: list[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create damage report form */},
        child: const Icon(Icons.add),
      ),
    );
  }
}
