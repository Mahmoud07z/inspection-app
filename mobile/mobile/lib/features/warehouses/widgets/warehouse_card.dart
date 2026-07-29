import 'package:flutter/material.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';

class WarehouseCard extends StatelessWidget {
  const WarehouseCard({super.key, required this.warehouse, this.onTap});
  final Warehouse warehouse;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE3F2FD),
        child: Icon(Icons.warehouse, color: Color(0xFF1565C0)),
      ),
      title: Text(warehouse.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(warehouse.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      trailing: warehouse.address != null
          ? Text(warehouse.address!, style: TextStyle(color: Colors.grey[600], fontSize: 12),
              overflow: TextOverflow.ellipsis)
          : null,
      onTap: onTap,
    ),
  );
}
