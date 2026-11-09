import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/features/inspections/widgets/inspection_card.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';
import 'package:inspection_app/features/warehouses/providers/warehouses_provider.dart';
import 'package:inspection_app/features/users/models/user.dart';
import 'package:inspection_app/features/users/providers/users_provider.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';

const _statuses = ['PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'];

class InspectionsScreen extends ConsumerStatefulWidget {
  const InspectionsScreen({super.key});

  @override
  ConsumerState<InspectionsScreen> createState() => _State();
}

class _State extends ConsumerState<InspectionsScreen> {
  String? _active;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inspectionsProvider);
    final warehouses = ref.watch(warehousesProvider).valueOrNull ?? [];
    final inspectors = ref
            .watch(usersProvider)
            .valueOrNull
            ?.where((u) => u.role == 'INSPECTOR')
            .toList() ??
        [];
    return Scaffold(
      appBar: const WorkspaceAppBar(title: 'Inspections'),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _Chip(null, _active, _onFilter),
                for (final s in _statuses) _Chip(s, _active, _onFilter),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorDisplay(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(inspectionsProvider)),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No inspections found'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => InspectionCard(
                        inspection: list[i],
                        onTap: () => context.go('/inspections/${list[i].id}'),
                        onDelete: () =>
                            _deleteInspection(context, ref, list[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: warehouses.isEmpty || inspectors.isEmpty
            ? null
            : () => _createInspection(context, ref, warehouses, inspectors),
        icon: const Icon(Icons.add),
        label: const Text('Inspection'),
      ),
    );
  }

  void _onFilter(String? status) {
    setState(() => _active = status);
    ref.read(inspectionsProvider.notifier).filter(status: status);
  }
}

Future<void> _createInspection(BuildContext context, WidgetRef ref,
    List<Warehouse> warehouses, List<AppUser> inspectors) async {
  final code = TextEditingController();
  final notes = TextEditingController();
  var warehouseId = warehouses.first.id;
  var inspectorId = inspectors.first.id;
  var scheduledDate = DateTime.now();
  await showAppFormDialog(
    context: context,
    title: 'Schedule inspection',
    fields: [
      TextFormField(
          controller: code,
          decoration: const InputDecoration(labelText: 'Inspection code'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Enter a code' : null),
      DropdownButtonFormField<int>(
        initialValue: warehouseId,
        decoration: const InputDecoration(labelText: 'Warehouse'),
        items: [
          for (final warehouse in warehouses)
            DropdownMenuItem(
                value: warehouse.id,
                child: Text('${warehouse.code} · ${warehouse.name}'))
        ],
        onChanged: (value) {
          if (value != null) warehouseId = value;
        },
      ),
      DropdownButtonFormField<int>(
        initialValue: inspectorId,
        decoration: const InputDecoration(labelText: 'Inspector'),
        items: [
          for (final inspector in inspectors)
            DropdownMenuItem(
                value: inspector.id,
                child: Text(inspector.fullName.isEmpty
                    ? inspector.username
                    : inspector.fullName))
        ],
        onChanged: (value) {
          if (value != null) inspectorId = value;
        },
      ),
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
                      lastDate: DateTime.now().add(const Duration(days: 3650)));
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
    onSave: () => ref.read(inspectionsProvider.notifier).add({
      'inspectionCode': code.text.trim(),
      'warehouseId': warehouseId,
      'inspectorId': inspectorId,
      'scheduledDate':
          '${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}',
      'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
    }),
  );
  code.dispose();
  notes.dispose();
}

Future<void> _deleteInspection(
    BuildContext context, WidgetRef ref, Inspection inspection) async {
  if (!await confirmDelete(context, inspection.inspectionCode)) return;
  try {
    await ref.read(inspectionsProvider.notifier).remove(inspection.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.status, this.active, this.onSelected);
  final String? status;
  final String? active;
  final void Function(String?) onSelected;

  @override
  Widget build(BuildContext context) {
    final label = status ?? 'All';
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: active == status,
        onSelected: (_) => onSelected(status),
      ),
    );
  }
}
