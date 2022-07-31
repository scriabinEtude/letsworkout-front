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
/// 빈문자열이거나 에러나면 0
int parseStringNumber(String text) {
  try {
    if (text.isEmpty) return 0;
    return int.parse(text);
  } catch (e) {
    return 0;
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

/// 소숫점이 0으로 시작하면 잘라내기
///
/// 아니면 소숫점 한자리까지 표시
///
/// **ex)**
/// ```
/// cutFixIfZero(1); // 1
/// cutFixIfZero(1.0); // 1
/// cutFixIfZero(1.5); // 1.5
/// cutFixIfZero(1.599); // 1.5
/// ```
String cutFixIfZero(double value) {
  return value.toStringAsFixed(1).replaceAll(RegExp(r'.0'), '');
}
