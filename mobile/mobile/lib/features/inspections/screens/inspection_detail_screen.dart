import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/core/utils/date_formatter.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/widgets/status_badge.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

const _nextStatus = {
  'PLANNED': 'IN_PROGRESS',
  'IN_PROGRESS': 'COMPLETED',
};

class InspectionDetailScreen extends ConsumerWidget {
  const InspectionDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection Detail')),
      body: ref.watch(inspectionDetailProvider(id)).when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
        data: (ins) {
          final next = _nextStatus[ins.status];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                Expanded(child: Text(ins.inspectionCode,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
                StatusBadge(status: ins.status),
              ]),
              const SizedBox(height: 16),
              _Row('Warehouse',     ins.warehouseCode),
              _Row('Inspector',     ins.inspectorName),
              _Row('Scheduled',     DateFormatter.display(ins.scheduledDate)),
              _Row('Damage reports', ins.damageReportCount.toString()),
              if (ins.notes != null) _Row('Notes', ins.notes!),
              _Row('Created',  DateFormatter.display(ins.createdAt)),
              _Row('Updated',  DateFormatter.display(ins.updatedAt)),
              const SizedBox(height: 24),
              if (ins.damageReportCount > 0)
                OutlinedButton.icon(
                  onPressed: () => context.go('${RouteNames.inspections}/$id/damage-reports'),
                  icon: const Icon(Icons.report_problem_outlined),
                  label: Text('View damage reports (${ins.damageReportCount})'),
                ),
              if (next != null) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref
                      .read(inspectionsProvider.notifier)
                      .transitionStatus(id, next),
                  child: Text('Mark as $next'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
