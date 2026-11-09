import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';
import 'package:inspection_app/core/utils/date_formatter.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/widgets/status_badge.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
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
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to inspections',
          onPressed: () => context.go(RouteNames.inspections),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Inspection Detail'),
        actions: [
          IconButton(
            tooltip: 'Edit inspection',
            onPressed: () async {
              try {
                final inspection =
                    await ref.read(inspectionDetailProvider(id).future);
                if (context.mounted) {
                  await _editInspection(context, ref, inspection);
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ref.watch(inspectionDetailProvider(id)).when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorDisplay(message: e.toString()),
            data: (ins) {
              final next = _nextStatus[ins.status];
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(ins.inspectionCode,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18))),
                    StatusBadge(status: ins.status),
                  ]),
                  const SizedBox(height: 16),
                  _Row('Warehouse', ins.warehouseCode),
                  _Row('Inspector', ins.inspectorName),
                  _Row('Scheduled', DateFormatter.display(ins.scheduledDate)),
                  _Row('Damage reports', ins.damageReportCount.toString()),
                  if (ins.notes != null) _Row('Notes', ins.notes!),
                  _Row('Created', DateFormatter.display(ins.createdAt)),
                  _Row('Updated', DateFormatter.display(ins.updatedAt)),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => context
                        .go('${RouteNames.inspections}/$id/damage-reports'),
                    icon: const Icon(Icons.report_problem_outlined),
                    label: Text('Damage reports (${ins.damageReportCount})'),
                  ),
                  if (next != null) ...[
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(inspectionsProvider.notifier)
                            .transitionStatus(id, next);
                        ref.invalidate(inspectionDetailProvider(id));
                      },
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

Future<void> _editInspection(
    BuildContext context, WidgetRef ref, Inspection inspection) async {
  final notes = TextEditingController(text: inspection.notes ?? '');
  var scheduledDate = inspection.scheduledDate;
  await showAppFormDialog(
    context: context,
    title: 'Edit inspection',
    fields: [
      StatefulBuilder(
          builder: (context, setDateState) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Scheduled date'),
                subtitle: Text(
                    '${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: scheduledDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (selected != null) {
                    setDateState(() => scheduledDate = selected);
                  }
                },
              )),
      TextFormField(
          controller: notes,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notes')),
    ],
    onSave: () async {
      await ref.read(inspectionsProvider.notifier).updateItem(inspection.id, {
        'scheduledDate':
            '${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}',
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
      });
      ref.invalidate(inspectionDetailProvider(inspection.id));
    },
  );
  notes.dispose();
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
            SizedBox(
                width: 110,
                child: Text(label,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500))),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
