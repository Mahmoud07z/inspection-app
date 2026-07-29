import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/widgets/inspection_card.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Inspections')),
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
                  message: e.toString(), onRetry: () => ref.invalidate(inspectionsProvider)),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No inspections found'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => InspectionCard(
                        inspection: list[i],
                        onTap: () => context.go('/inspections/${list[i].id}'),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create inspection form */},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFilter(String? status) {
    setState(() => _active = status);
    ref.read(inspectionsProvider.notifier).filter(status: status);
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
