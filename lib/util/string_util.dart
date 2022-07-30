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

/// 문자열형 숫자를 int로 변환
///
/// 빈문자열이거나 에러나면 null로
int? parseStringNumber(String text) {
  try {
    if (text.isEmpty) return null;
    return int.parse(text);
  } catch (e) {
    return null;
  }
}

String? emptyToNull(String text) {
  return text.isEmpty ? null : text;
}

/// ```
///
/// value.toString()
/// null -> ''
/// ```
String intToString(int? value) {
  if (value == null) return "";
  return value.toString();
}
