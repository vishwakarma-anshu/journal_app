import 'package:intl/intl.dart';

class FormatDate {
  /// Returns the date in ("Jun 6, 2020") format.
  String dateFormateShortMonthDayYear(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date)).toString();
  }

  /// Returns the date in ("7" i.e is the date) format.
  String dateFormateShortDayNumber(String date) {
    return DateFormat.d().format(DateTime.parse(date)).toString();
  }

  /// Return the date in ("Sun" i.e the weekday) format.
  String dateFormatShortDayName(String date) {
    return DateFormat.E().format(DateTime.parse(date)).toString();
  }
}
