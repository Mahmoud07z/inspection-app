import 'package:flutter/material.dart';
import 'package:inspection_app/features/damage_reports/models/damage_report.dart';
import 'package:inspection_app/features/damage_reports/widgets/severity_badge.dart';

class DamageReportTile extends StatelessWidget {
  const DamageReportTile({super.key, required this.report, this.onTap});
  final DamageReport report;
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
                child: Text(report.articleName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              SeverityBadge(severity: report.severity),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
              const SizedBox(width: 2),
              Text(report.locationCode,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            const SizedBox(height: 6),
            Text(report.description,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}
