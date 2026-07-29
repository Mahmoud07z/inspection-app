import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/locations/models/location.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(ref.read(apiServiceProvider)),
);

class LocationService {
  LocationService(this._api);
  final ApiService _api;

  Future<List<Location>> getByWarehouse(int warehouseId) async {
    final r = await _api.client.get(ApiConstants.locations,
        queryParameters: {'warehouseId': warehouseId});
    return (r.data as List).map((e) => Location.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Location> getById(int id) async {
    final r = await _api.client.get(ApiConstants.locationById(id));
    return Location.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Location> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.locations, data: body);
    return Location.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Location> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.locationById(id), data: body);
    return Location.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.locationById(id));
}
