import 'package:flutter/material.dart';
import 'package:inspection_app/features/locations/models/location.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, this.onTap});
  final Location location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.location_on_outlined, color: Color(0xFF1565C0)),
    title: Text(location.code, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: location.description != null ? Text(location.description!) : null,
    trailing: Text(location.warehouseCode,
        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
    onTap: onTap,
  );
}
