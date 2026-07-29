import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/auth/models/jwt_response.dart';
import 'package:inspection_app/features/auth/models/login_request.dart';
import 'package:inspection_app/features/auth/services/auth_service.dart';
import 'package:inspection_app/shared/services/api_service.dart';

/// AsyncValue<JwtResponse?> states:
///   AsyncLoading        → restoring persisted token on app start
///   AsyncData(null)     → not authenticated
///   AsyncData(jwt)      → authenticated
///   AsyncError          → login failed (contains ApiError)
final authProvider =
    AsyncNotifierProvider<AuthNotifier, JwtResponse?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<JwtResponse?> {
  @override
  Future<JwtResponse?> build() async {
    final token = await ref.read(apiServiceProvider).readToken();
    if (token == null) return null;
    return JwtResponse(token: token, type: 'Bearer', username: '', role: '');
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final jwt = await ref.read(authServiceProvider).login(
        LoginRequest(username: username, password: password),
      );
      await ref.read(apiServiceProvider).saveToken(jwt.token);
      return jwt;
    });
  }

  Future<void> logout() async {
    await ref.read(apiServiceProvider).deleteToken();
    state = const AsyncData(null);
  }
}
