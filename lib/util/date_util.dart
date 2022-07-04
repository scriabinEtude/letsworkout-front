import 'package:intl/intl.dart';

String getYearMonth(DateTime date) {
  return date.toString().substring(0, 7);
}

String getYearMonthDay(DateTime date) {
  return date.toString().substring(0, 10);
}

String mysqlDateTimeFormat(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd kk:mm:ss').format(dateTime);
}
