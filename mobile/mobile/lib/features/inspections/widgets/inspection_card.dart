import 'package:flutter/material.dart';
import 'package:inspection_app/core/utils/date_formatter.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/features/inspections/widgets/status_badge.dart';

class InspectionCard extends StatelessWidget {
  const InspectionCard({super.key, required this.inspection, this.onTap});
  final Inspection inspection;
  final VoidCallback? onTap;

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
                child: Text(inspection.inspectionCode,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              ),
              StatusBadge(status: inspection.status),
            ]),
            const SizedBox(height: 4),
            Text('${inspection.warehouseCode} · ${inspection.inspectorName}',
                style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(DateFormatter.display(inspection.scheduledDate),
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              if (inspection.damageReportCount > 0)
                Chip(
                  label: Text('${inspection.damageReportCount} reports',
                      style: const TextStyle(fontSize: 11)),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFFFFF3E0),
                ),
            ]),
          ],
        ),
      ),
    ),
  );
}
