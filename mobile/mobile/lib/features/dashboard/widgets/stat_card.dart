import 'package:flutter/material.dart';

/// Compact, tappable metric tile used by the dashboard overview.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.icon,
    this.count,
    this.tint = const Color(0xFFEAF1FF),
    this.onTap,
  });

  final String label;
  final IconData icon;
  final int? count;
  final Color tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: scheme.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color:
                          isDark ? scheme.primary.withValues(alpha: .14) : tint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: scheme.primary),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_outward_rounded,
                      size: 16, color: Colors.blueGrey.shade300),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count?.toString() ?? '—',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
