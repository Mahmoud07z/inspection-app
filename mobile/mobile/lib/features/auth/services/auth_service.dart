import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/auth/models/jwt_response.dart';
import 'package:inspection_app/features/auth/models/login_request.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(apiServiceProvider)),
);

class AuthService {
  AuthService(this._api);
  final ApiService _api;

  Future<JwtResponse> login(LoginRequest req) async {
    final res = await _api.client.post(ApiConstants.login, data: req.toJson());
    return JwtResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
