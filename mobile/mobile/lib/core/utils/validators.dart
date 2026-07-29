/// Form validators that mirror backend Bean Validation rules.
/// Returns null on pass, an error string on fail — matches [TextFormField.validator].
abstract final class Validators {
  static String? username(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    if (v.length > 50) return 'Username must not exceed 50 characters';
    if (!RegExp(r'^[a-zA-Z0-9_.\-]+$').hasMatch(v)) {
      return 'Only letters, digits, dots, hyphens, and underscores are allowed';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8)   return 'Password must be at least 8 characters';
    if (v.length > 100) return 'Password must not exceed 100 characters';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Validates warehouse/article/location/inspection codes (barcode-safe format).
  static String? code(String? v, {String label = 'Code'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9\-_.]*$').hasMatch(v)) {
      return '$label must start with a letter or digit and contain only letters, digits, hyphens, underscores, and dots';
    }
    return null;
  }

  static String? required(String? v, {required String label}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }
}
