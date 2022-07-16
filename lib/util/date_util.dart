String getYearMonth(DateTime date) {
  return date.toString().substring(0, 7);
}

String getYearMonthDay(DateTime date) {
  return date.toString().substring(0, 10);
}

String mysqlDateTimeFormat(DateTime dateTime) {
  return dateTime.toIso8601String().substring(0, 19).replaceAll("T", " ");
}
