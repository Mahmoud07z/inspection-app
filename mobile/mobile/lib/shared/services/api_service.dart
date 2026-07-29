import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/shared/models/api_error.dart';

<<<<<<< HEAD
const _kToken = 'jwt_token';

final apiServiceProvider = Provider<ApiService>((_) => ApiService._());

/// Shared Dio client used by every feature service.
///
/// - [_JwtInterceptor]   injects `Authorization: Bearer <token>` from the OS keychain.
/// - [_ErrorInterceptor] converts 4xx/5xx responses into typed [ApiError] objects.
/// - Token helpers are used by the auth feature on login / logout.
class ApiService {
  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.addAll([_JwtInterceptor(_s), _ErrorInterceptor()]);
  }

  late final Dio _dio;
  final _s = const FlutterSecureStorage();

  Dio get client => _dio;

  Future<void>    saveToken(String t) => _s.write(key: _kToken, value: t);
  Future<String?> readToken()         => _s.read(key: _kToken);
  Future<void>    deleteToken()       => _s.delete(key: _kToken);
}

class _JwtInterceptor extends Interceptor {
  _JwtInterceptor(this._s);
  final FlutterSecureStorage _s;

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) async {
    final t = await _s.read(key: _kToken);
    if (t != null) o.headers['Authorization'] = 'Bearer $t';
    h.next(o);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler h) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      h.reject(DioException(
        requestOptions: err.requestOptions,
        error: ApiError.fromJson(data),
        response: err.response,
        type: err.type,
      ));
    } else {
      h.next(err);
=======
const _kTokenKey = 'jwt_token';

/// Provides the [ApiService] singleton to the Riverpod tree.
final apiServiceProvider = Provider<ApiService>((_) => ApiService._());

/// Shared Dio-based HTTP client used by every feature service.
///
/// Responsibilities:
/// - Centralises [ApiConstants.baseUrl], timeout settings, and default headers.
/// - [_JwtInterceptor]: reads the JWT from OS secure storage and injects
///   `Authorization: Bearer <token>` on every outgoing request.
/// - [_ErrorInterceptor]: converts 4xx / 5xx [DioException] into typed
///   [ApiError] objects — feature services never need to parse raw bodies
///   in `catch` blocks.
/// - Token helpers ([saveToken], [readToken], [deleteToken]) used by the
///   auth feature on login / logout.
class ApiService {
  ApiService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.addAll([
      _JwtInterceptor(_storage),
      _ErrorInterceptor(),
    ]);
  }

  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  /// Exposes the Dio client to feature services.
  Dio get client => _dio;

  Future<void> saveToken(String token) =>
      _storage.write(key: _kTokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _kTokenKey);

  Future<void> deleteToken() => _storage.delete(key: _kTokenKey);
}

/// Reads the JWT from the OS keychain / keystore and appends it to every request.
class _JwtInterceptor extends Interceptor {
  _JwtInterceptor(this._storage);
  final FlutterSecureStorage _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: _kTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Converts a [DioException] with a known error body into a typed [ApiError].
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ApiError.fromJson(data),
          response: err.response,
          type: err.type,
        ),
      );
    } else {
      handler.next(err);
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    }
  }
}
