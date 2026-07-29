import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/damage_reports/models/damage_report.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final damageReportServiceProvider = Provider<DamageReportService>(
  (ref) => DamageReportService(ref.read(apiServiceProvider)),
);

class DamageReportService {
  DamageReportService(this._api);
  final ApiService _api;

  Future<List<DamageReport>> getByInspection(int inspectionId) async {
    final r = await _api.client.get(ApiConstants.damageReports,
        queryParameters: {'inspectionId': inspectionId});
    return (r.data as List).map((e) => DamageReport.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<DamageReport>> getByArticle(int articleId) async {
    final r = await _api.client.get(ApiConstants.damageReports,
        queryParameters: {'articleId': articleId});
    return (r.data as List).map((e) => DamageReport.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DamageReport> getById(int id) async {
    final r = await _api.client.get(ApiConstants.damageReportById(id));
    return DamageReport.fromJson(r.data as Map<String, dynamic>);
  }

  Future<DamageReport> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.damageReports, data: body);
    return DamageReport.fromJson(r.data as Map<String, dynamic>);
  }

  Future<DamageReport> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.damageReportById(id), data: body);
    return DamageReport.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.damageReportById(id));
}
