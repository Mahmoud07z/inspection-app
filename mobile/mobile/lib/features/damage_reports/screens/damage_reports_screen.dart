import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/articles/models/article.dart';
import 'package:inspection_app/features/articles/services/article_service.dart';
import 'package:inspection_app/features/damage_reports/models/damage_report.dart';
import 'package:inspection_app/features/damage_reports/providers/damage_reports_provider.dart';
import 'package:inspection_app/features/damage_reports/widgets/damage_report_tile.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/features/inspections/providers/inspections_provider.dart';
import 'package:inspection_app/features/inspections/services/inspection_service.dart';
import 'package:inspection_app/features/locations/models/location.dart';
import 'package:inspection_app/features/locations/services/location_service.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';
import 'package:inspection_app/shared/widgets/qr_scanner_dialog.dart';

class DamageReportsScreen extends ConsumerStatefulWidget {
  const DamageReportsScreen({super.key, required this.inspectionId});
  final int inspectionId;

  @override
  ConsumerState<DamageReportsScreen> createState() =>
      _DamageReportsScreenState();
}

class _DamageReportsScreenState extends ConsumerState<DamageReportsScreen> {
  int? _selectedInspectionId;

  @override
  Widget build(BuildContext context) {
    final inspectionsState = ref.watch(inspectionsProvider);
    final inspections = inspectionsState.valueOrNull ?? <Inspection>[];
    final requestedId =
        widget.inspectionId > 0 ? widget.inspectionId : _selectedInspectionId;
    final selectedId =
        widget.inspectionId > 0
            ? widget.inspectionId
            : inspections.any((i) => i.id == requestedId)
            ? requestedId
            : inspections.isEmpty
            ? null
            : inspections.first.id;

    return Scaffold(
      appBar: const WorkspaceAppBar(title: 'Damage Reports'),
      drawer: const AppDrawer(),
      body:
          selectedId == null
              ? inspectionsState.when(
                loading: () => const LoadingIndicator(),
                error:
                    (error, _) => ErrorDisplay(
                      message: error.toString(),
                      onRetry: () => ref.invalidate(inspectionsProvider),
                    ),
                data:
                    (_) => const Center(
                      child: Text(
                        'Create an inspection before filing damage reports',
                      ),
                    ),
              )
              : Column(
                children: [
                  if (widget.inspectionId <= 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: DropdownButtonFormField<int>(
                        initialValue: selectedId,
                        decoration: const InputDecoration(
                          labelText: 'Inspection',
                        ),
                        items: [
                          for (final inspection in inspections)
                            DropdownMenuItem(
                              value: inspection.id,
                              child: Text(
                                '${inspection.inspectionCode} · ${inspection.warehouseCode}',
                              ),
                            ),
                        ],
                        onChanged:
                            (id) => setState(() => _selectedInspectionId = id),
                      ),
                    ),
                  Expanded(child: _reportList(context, selectedId)),
                ],
              ),
      floatingActionButton:
          selectedId == null
              ? null
              : FloatingActionButton.extended(
                onPressed: () => _editReport(context, selectedId, null),
                icon: const Icon(Icons.add),
                label: const Text('Damage report'),
              ),
    );
  }

  Widget _reportList(BuildContext context, int inspectionId) {
    final state = ref.watch(damageReportsProvider(inspectionId));
    return state.when(
      loading: () => const LoadingIndicator(),
      error:
          (error, _) => ErrorDisplay(
            message: error.toString(),
            onRetry: () => ref.invalidate(damageReportsProvider(inspectionId)),
          ),
      data:
          (reports) =>
              reports.isEmpty
                  ? const Center(
                    child: Text('No damage reports for this inspection'),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final report = reports[index];
                      return DamageReportTile(
                        report: report,
                        onTap: () => _editReport(context, inspectionId, report),
                        onEdit:
                            () => _editReport(context, inspectionId, report),
                        onDelete:
                            () => _deleteReport(context, inspectionId, report),
                      );
                    },
                  ),
    );
  }

  Future<void> _editReport(
    BuildContext context,
    int inspectionId,
    DamageReport? report,
  ) async {
    try {
      final inspection = await ref
          .read(inspectionServiceProvider)
          .getById(inspectionId);
      final articles = await ref.read(articleServiceProvider).getAll();
      final locations = await ref
          .read(locationServiceProvider)
          .getByWarehouse(inspection.warehouseId);
      if (!context.mounted) return;
      if (articles.isEmpty || locations.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add an article and a warehouse location first'),
            ),
          );
        }
        return;
      }

      final description = TextEditingController(
        text: report?.description ?? '',
      );
      final photoUrl = TextEditingController(text: report?.photoUrl ?? '');
      var articleId = report?.articleId ?? articles.first.id;
      var locationId = report?.locationId ?? locations.first.id;
      var severity = report?.severity ?? 'LOW';
      await showAppFormDialog(
        context: context,
        title: report == null ? 'New damage report' : 'Edit damage report',
        fields: [
          if (report == null)
            StatefulBuilder(
              builder:
                  (dialogContext, setArticleState) => Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          key: ValueKey(articleId),
                          initialValue: articleId,
                          decoration: const InputDecoration(
                            labelText: 'Article',
                          ),
                          items: [
                            for (final article in articles)
                              _articleOption(article),
                          ],
                          onChanged: (id) {
                            if (id != null) articleId = id;
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: 'Scan article QR code',
                        onPressed: () async {
                          final code = await scanQrCode(dialogContext);
                          if (!dialogContext.mounted || code == null) return;
                          final article =
                              articles
                                  .where(
                                    (item) =>
                                        item.code.toLowerCase() ==
                                        code.toLowerCase(),
                                  )
                                  .firstOrNull;
                          if (article == null) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No article matches QR code "$code".',
                                ),
                              ),
                            );
                            return;
                          }
                          setArticleState(() => articleId = article.id);
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Article selected: ${article.name}',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                      ),
                    ],
                  ),
            ),
          if (report == null)
            DropdownButtonFormField<int>(
              initialValue: locationId,
              decoration: const InputDecoration(labelText: 'Location'),
              items: [
                for (final location in locations) _locationOption(location),
              ],
              onChanged: (id) {
                if (id != null) locationId = id;
              },
            ),
          DropdownButtonFormField<String>(
            initialValue: severity,
            decoration: const InputDecoration(labelText: 'Severity'),
            items: const [
              DropdownMenuItem(value: 'LOW', child: Text('Low')),
              DropdownMenuItem(value: 'MEDIUM', child: Text('Medium')),
              DropdownMenuItem(value: 'HIGH', child: Text('High')),
              DropdownMenuItem(value: 'CRITICAL', child: Text('Critical')),
            ],
            onChanged: (value) {
              if (value != null) severity = value;
            },
          ),
          TextFormField(
            controller: description,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'What happened?'),
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Describe the damage'
                        : null,
          ),
          TextFormField(
            controller: photoUrl,
            decoration: const InputDecoration(
              labelText: 'Photo URL (optional)',
            ),
          ),
        ],
        onSave: () async {
          if (report == null) {
            await ref.read(damageReportsProvider(inspectionId).notifier).add({
              'inspectionId': inspectionId,
              'articleId': articleId,
              'locationId': locationId,
              'severity': severity,
              'description': description.text.trim(),
              'photoUrl':
                  photoUrl.text.trim().isEmpty ? null : photoUrl.text.trim(),
            });
          } else {
            await ref
                .read(damageReportsProvider(inspectionId).notifier)
                .updateItem(report.id, {
                  'severity': severity,
                  'description': description.text.trim(),
                  'photoUrl':
                      photoUrl.text.trim().isEmpty
                          ? null
                          : photoUrl.text.trim(),
                });
          }
          ref.invalidate(inspectionDetailProvider(inspectionId));
        },
      );
      description.dispose();
      photoUrl.dispose();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _deleteReport(
    BuildContext context,
    int inspectionId,
    DamageReport report,
  ) async {
    if (!await confirmDelete(context, report.articleName)) return;
    try {
      await ref
          .read(damageReportsProvider(inspectionId).notifier)
          .remove(report.id);
      ref.invalidate(inspectionDetailProvider(inspectionId));
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

DropdownMenuItem<int> _articleOption(Article article) => DropdownMenuItem(
  value: article.id,
  child: Text('${article.code} · ${article.name}'),
);

DropdownMenuItem<int> _locationOption(Location location) =>
    DropdownMenuItem(value: location.id, child: Text(location.code));
