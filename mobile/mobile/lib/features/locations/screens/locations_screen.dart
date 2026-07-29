import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/locations/providers/locations_provider.dart';
import 'package:inspection_app/features/locations/widgets/location_tile.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key, this.warehouseId});
  final int? warehouseId;

  @override
  ConsumerState<LocationsScreen> createState() => _State();
}

class _State extends ConsumerState<LocationsScreen> {
  // Default to 1 until a warehouse-picker flow is implemented.
  int get _wid => widget.warehouseId ?? 1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationsProvider(_wid));
    return Scaffold(
      appBar: AppBar(title: const Text('Locations')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(
            message: e.toString(), onRetry: () => ref.invalidate(locationsProvider(_wid))),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No locations found'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) => LocationTile(location: list[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create location form */},
        child: const Icon(Icons.add),
      ),
    );
  }
}
