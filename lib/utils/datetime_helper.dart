import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._internal();

  static String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('d MMM yyyy');
    return formatter.format(date);
  }

  static String formatToDay(DateTime date) {
    DateFormat formatter = DateFormat('EEEE');
    return formatter.format(date);
  }

  static bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(today.year, today.month, today.day))
            .inDays ==
        0;
  }
}
