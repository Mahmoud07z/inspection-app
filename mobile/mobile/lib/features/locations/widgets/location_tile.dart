import 'package:flutter/material.dart';
import 'package:inspection_app/features/locations/models/location.dart';

class LocationTile extends StatelessWidget {
  const LocationTile(
      {super.key,
      required this.location,
      this.onTap,
      this.onEdit,
      this.onDelete});
  final Location location;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.location_on_outlined,
            color: Theme.of(context).colorScheme.primary),
        title: Text(location.code,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle:
            location.description != null ? Text(location.description!) : null,
        trailing: PopupMenuButton<String>(
          onSelected: (action) =>
              action == 'edit' ? onEdit?.call() : onDelete?.call(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: onTap,
      );
}
