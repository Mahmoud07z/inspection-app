import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/warehouses/models/warehouse.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final warehouseServiceProvider = Provider<WarehouseService>(
  (ref) => WarehouseService(ref.read(apiServiceProvider)),
);

class WarehouseService {
  WarehouseService(this._api);
  final ApiService _api;

  Future<List<Warehouse>> getAll({String? name}) async {
    final r = await _api.client.get(ApiConstants.warehouses,
        queryParameters: name != null ? {'name': name} : null);
    return (r.data as List).map((e) => Warehouse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Warehouse> getById(int id) async {
    final r = await _api.client.get(ApiConstants.warehouseById(id));
    return Warehouse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Warehouse> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.warehouses, data: body);
    return Warehouse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Warehouse> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.warehouseById(id), data: body);
    return Warehouse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.warehouseById(id));
}
