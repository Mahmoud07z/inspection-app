import 'package:flutter/material.dart';

/// Tappable summary card used on the Dashboard overview grid.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.icon,
    this.count,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: scheme.primary),
              const SizedBox(height: 8),
              if (count != null)
                Text('$count',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary)),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
