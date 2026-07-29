/// Mirrors the backend ErrorResponse record.
/// Raised by [_ErrorInterceptor] so feature services catch a typed error.
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
  final List<String>? errors;

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    status:    json['status']    as int,
    message:   json['message']   as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    errors: (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
  );

  String get displayMessage =>
      (errors?.isNotEmpty ?? false) ? errors!.first : message;

  @override
  String toString() => 'ApiError($status): $message';
}
