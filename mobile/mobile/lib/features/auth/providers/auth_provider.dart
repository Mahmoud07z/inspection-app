import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/auth/models/jwt_response.dart';
import 'package:inspection_app/features/auth/models/login_request.dart';
import 'package:inspection_app/features/auth/services/auth_service.dart';
import 'package:inspection_app/shared/services/api_service.dart';

<<<<<<< HEAD
/// AsyncValue<JwtResponse?> states:
///   AsyncLoading        → restoring persisted token on app start
///   AsyncData(null)     → not authenticated
///   AsyncData(jwt)      → authenticated
///   AsyncError          → login failed (contains ApiError)
=======
/// Exposes the current authentication state as [AsyncValue<JwtResponse?>].
///
/// State semantics:
/// - [AsyncLoading]      : restoring a persisted token on app start.
/// - [AsyncData(null)]   : not authenticated.
/// - [AsyncData(jwt)]    : authenticated; [jwt.token] is valid.
/// - [AsyncError]        : login failed (contains a typed [ApiError]).
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
final authProvider =
    AsyncNotifierProvider<AuthNotifier, JwtResponse?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<JwtResponse?> {
<<<<<<< HEAD
=======
  /// On first build, attempt to restore a token persisted from the previous session.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  @override
  Future<JwtResponse?> build() async {
    final token = await ref.read(apiServiceProvider).readToken();
    if (token == null) return null;
<<<<<<< HEAD
    return JwtResponse(token: token, type: 'Bearer', username: '', role: '');
  }

=======
    // Reconstruct a minimal JwtResponse from the persisted token.
    // A production app would also store username / role in secure storage.
    return JwtResponse(token: token, type: 'Bearer', username: '', role: '');
  }

  /// Calls the backend, stores the token, and updates state.
  /// On failure, [state] becomes [AsyncError] with the [ApiError].
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
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

<<<<<<< HEAD
=======
  /// Deletes the stored token and returns to the unauthenticated state.
  /// GoRouter's redirect will push the user to [RouteNames.login].
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  Future<void> logout() async {
    await ref.read(apiServiceProvider).deleteToken();
    state = const AsyncData(null);
  }
}
