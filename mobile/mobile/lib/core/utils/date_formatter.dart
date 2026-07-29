import 'package:intl/intl.dart';

<<<<<<< HEAD
abstract final class DateFormatter {
  static final _date     = DateFormat('MMM d, yyyy');
  static final _dateTime = DateFormat('MMM d, yyyy  HH:mm');
  static final _api      = DateFormat('yyyy-MM-dd');

  static String display(DateTime dt)         => _date.format(dt.toLocal());
  static String displayWithTime(DateTime dt) => _dateTime.format(dt.toLocal());
  static String toApiDate(DateTime dt)       => _api.format(dt);
  static DateTime fromIso(String iso)        => DateTime.parse(iso);

  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inDays > 30)    return _date.format(dt.toLocal());
    if (diff.inDays > 0)     return '${diff.inDays}d ago';
    if (diff.inHours > 0)    return '${diff.inHours}h ago';
    if (diff.inMinutes > 0)  return '${diff.inMinutes}m ago';
=======
/// Utility class for all date/time display formatting.
///
/// The backend stores timestamps as ISO-8601 UTC strings ([Instant]).
/// All display methods convert to the device's local time zone.
abstract final class DateFormatter {
  static final _date         = DateFormat('MMM d, yyyy');
  static final _dateTime     = DateFormat('MMM d, yyyy  HH:mm');
  static final _apiDateFormat = DateFormat('yyyy-MM-dd');

  /// e.g. "Jul 24, 2026"
  static String display(DateTime dt) => _date.format(dt.toLocal());

  /// e.g. "Jul 24, 2026  14:30"
  static String displayWithTime(DateTime dt) => _dateTime.format(dt.toLocal());

  /// Formats a [DateTime] as `yyyy-MM-dd` for the REST API body.
  static String toApiDate(DateTime dt) => _apiDateFormat.format(dt);

  /// Parses an ISO-8601 string from the API into a [DateTime].
  static DateTime fromIso(String iso) => DateTime.parse(iso);

  /// Returns a human-readable relative string, e.g. "3d ago" or "just now".
  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inDays > 30)  return _date.format(dt.toLocal());
    if (diff.inDays  > 0)  return '${diff.inDays}d ago';
    if (diff.inHours > 0)  return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    return 'just now';
  }
}
