import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/shared/models/api_error.dart';

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
    }
  }
}
