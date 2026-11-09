import 'package:flutter/material.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';

class WarehouseCard extends StatelessWidget {
  const WarehouseCard(
      {super.key,
      required this.warehouse,
      this.onTap,
      this.onEdit,
      this.onDelete});
  final Warehouse warehouse;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(Icons.warehouse,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          title: Text(warehouse.name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(warehouse.code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          trailing: PopupMenuButton<String>(
            onSelected: (action) =>
                action == 'edit' ? onEdit?.call() : onDelete?.call(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
          onTap: onTap,
        ),
      );
}
