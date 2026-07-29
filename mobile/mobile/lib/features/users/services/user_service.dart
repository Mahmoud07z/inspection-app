import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/users/models/user.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.read(apiServiceProvider)),
);

class UserService {
  UserService(this._api);
  final ApiService _api;

  Future<List<AppUser>> getAll({String? role}) async {
    final r = await _api.client.get(ApiConstants.users,
        queryParameters: role != null ? {'role': role} : null);
    return (r.data as List).map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AppUser> getById(int id) async {
    final r = await _api.client.get(ApiConstants.userById(id));
    return AppUser.fromJson(r.data as Map<String, dynamic>);
  }

  Future<AppUser> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.users, data: body);
    return AppUser.fromJson(r.data as Map<String, dynamic>);
  }

  Future<AppUser> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.userById(id), data: body);
    return AppUser.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.userById(id));
}
