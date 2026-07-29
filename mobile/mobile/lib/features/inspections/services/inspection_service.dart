import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/inspections/models/inspection.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final inspectionServiceProvider = Provider<InspectionService>(
  (ref) => InspectionService(ref.read(apiServiceProvider)),
);

class InspectionService {
  InspectionService(this._api);
  final ApiService _api;

  Future<List<Inspection>> getAll({int? warehouseId, int? inspectorId, String? status}) async {
    final query = <String, dynamic>{
      if (warehouseId != null) 'warehouseId': warehouseId,
      if (inspectorId != null) 'inspectorId': inspectorId,
      if (status != null) 'status': status,
    };
    final r = await _api.client.get(ApiConstants.inspections,
        queryParameters: query.isEmpty ? null : query);
    return (r.data as List).map((e) => Inspection.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Inspection> getById(int id) async {
    final r = await _api.client.get(ApiConstants.inspectionById(id));
    return Inspection.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Inspection> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.inspections, data: body);
    return Inspection.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Inspection> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.inspectionById(id), data: body);
    return Inspection.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Inspection> updateStatus(int id, String status) async {
    final r = await _api.client.patch(ApiConstants.inspectionStatus(id),
        data: {'status': status});
    return Inspection.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.inspectionById(id));
}
