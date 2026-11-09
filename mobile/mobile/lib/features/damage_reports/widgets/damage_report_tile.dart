import 'package:flutter/material.dart';
import 'package:inspection_app/features/damage_reports/models/damage_report.dart';
import 'package:inspection_app/features/damage_reports/widgets/severity_badge.dart';

class DamageReportTile extends StatelessWidget {
  const DamageReportTile(
      {super.key,
      required this.report,
      this.onTap,
      this.onEdit,
      this.onDelete});
  final DamageReport report;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(report.articleName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  SeverityBadge(severity: report.severity),
                  PopupMenuButton<String>(
                    onSelected: (action) =>
                        action == 'edit' ? onEdit?.call() : onDelete?.call(),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.location_on_outlined,
                      size: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text(report.locationCode,
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ]),
                const SizedBox(height: 6),
                Text(report.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      );
}
