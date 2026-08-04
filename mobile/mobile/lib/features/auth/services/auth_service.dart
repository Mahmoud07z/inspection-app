import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/auth/models/jwt_response.dart';
import 'package:inspection_app/features/auth/models/login_request.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(apiServiceProvider)),
);

/// Calls the authentication endpoint and returns a [JwtResponse].
/// Any error is propagated as a typed [ApiError] by [ApiService]'s interceptor.
class AuthService {
  AuthService(this._api);
  final ApiService _api;

  Future<JwtResponse> login(LoginRequest request) async {
    final response = await _api.client.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return JwtResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
