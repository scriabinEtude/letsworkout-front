String onlyNumber(String text) {
  return text.replaceAll(RegExp(r'[^0-9]'), "");
}

int? parseOnlyNumber(String text) {
  String number = onlyNumber(text);
  if (number.isEmpty) {
    return null;
  }
  return int.parse(onlyNumber(text));
}
