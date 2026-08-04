/// Mirrors the backend [ErrorResponse] record.
/// Thrown by [ApiService]'s [_ErrorInterceptor] so that every feature service
/// catches a typed error instead of parsing raw [DioException] bodies.
class ApiError implements Exception {
  const ApiError({
    required this.status,
    required this.message,
    required this.timestamp,
    this.errors,
  });

  final int status;
  final String message;
  final DateTime timestamp;

  /// Non-null when the backend returns a validation errors list (400).
  final List<String>? errors;

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    status:    json['status']    as int,
    message:   json['message']   as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  /// Returns the first validation error, or the generic message.
  String get displayMessage =>
      (errors?.isNotEmpty ?? false) ? errors!.first : message;

  @override
  String toString() => 'ApiError($status): $message';
}
