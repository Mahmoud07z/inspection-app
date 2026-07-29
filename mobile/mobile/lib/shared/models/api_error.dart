<<<<<<< HEAD
/// Mirrors the backend ErrorResponse record.
/// Raised by [_ErrorInterceptor] so feature services catch a typed error.
=======
/// Mirrors the backend [ErrorResponse] record.
/// Thrown by [ApiService]'s [_ErrorInterceptor] so that every feature service
/// catches a typed error instead of parsing raw [DioException] bodies.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
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
<<<<<<< HEAD
=======

  /// Non-null when the backend returns a validation errors list (400).
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  final List<String>? errors;

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    status:    json['status']    as int,
    message:   json['message']   as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
<<<<<<< HEAD
    errors: (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
  );

=======
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  /// Returns the first validation error, or the generic message.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  String get displayMessage =>
      (errors?.isNotEmpty ?? false) ? errors!.first : message;

  @override
  String toString() => 'ApiError($status): $message';
}
