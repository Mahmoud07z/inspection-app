import 'package:intl/intl.dart';

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
    return 'just now';
  }
}
