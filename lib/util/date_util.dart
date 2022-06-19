String getYearMonth(DateTime date) {
  return date.toString().substring(0, 7);
}

String getYearMonthDay(DateTime date) {
  return date.toString().substring(0, 10);
}
