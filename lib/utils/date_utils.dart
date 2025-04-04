import 'package:intl/intl.dart';

/// Utility class for date and time operations
class DateUtils {
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  /// Formats a [DateTime] to dd/MM/yyyy format
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formats a [DateTime] to HH:mm format
  static String formatTime(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// Formats a [DateTime] to dd/MM/yyyy HH:mm format
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Returns a human-readable string representing how long ago the date was
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} anos atrás';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} meses atrás';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'Agora';
    }
  }

  /// Checks if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Returns a DateTime set to the start of the day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns a DateTime set to the end of the day (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Returns a DateTime set to the start of the week (Sunday)
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday));
  }

  /// Returns a DateTime set to the end of the week (Saturday 23:59:59)
  static DateTime endOfWeek(DateTime date) {
    final end = date.add(Duration(days: 6 - date.weekday));
    return endOfDay(end);
  }
}
