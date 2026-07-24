/// Form field validators that mirror the Bean Validation constraints on the backend.
///
/// Each function returns `null` on success or a non-null error message on failure,
/// matching the signature expected by [TextFormField.validator].
abstract final class Validators {
  // ── Username ──────────────────────────────────────────────────
  static String? username(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    if (v.length > 50) return 'Username must not exceed 50 characters';
    if (!RegExp(r'^[a-zA-Z0-9_.\-]+$').hasMatch(v)) {
      return 'Only letters, digits, dots, hyphens, and underscores are allowed';
    }
    return null;
  }

  // ── Password ──────────────────────────────────────────────────
  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8)   return 'Password must be at least 8 characters';
    if (v.length > 100) return 'Password must not exceed 100 characters';
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) {
      return 'Enter a valid email address';
    }
    if (v.length > 100) return 'Email must not exceed 100 characters';
    return null;
  }

  // ── Code / Barcode ────────────────────────────────────────────
  /// Validates warehouse codes, article SKUs, location codes, inspection codes.
  /// Must start with a letter or digit, may contain hyphens/underscores/dots.
  static String? code(String? v, {String label = 'Code'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9\-_.]*$').hasMatch(v)) {
      return '$label must start with a letter or digit and contain only letters, digits, hyphens, underscores, and dots';
    }
    return null;
  }

  // ── Generic required text ─────────────────────────────────────
  static String? required(String? v, {required String label}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  // ── Optional max-length ───────────────────────────────────────
  static String? maxLength(String? v, int max, {required String label}) {
    if (v != null && v.length > max) {
      return '$label must not exceed $max characters';
    }
    return null;
  }
}
