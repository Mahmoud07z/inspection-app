import 'package:flutter/material.dart';
import 'package:inspection_app/core/utils/extensions.dart';

class SeverityBadge extends StatelessWidget {
  const SeverityBadge({super.key, required this.severity});
  final String severity;

  @override
  Widget build(BuildContext context) {
    final color = severity.severityColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(severity,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
