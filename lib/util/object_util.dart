///```
/// Iterable<dynamic> 을 List로 변환
/// null이면 빈 배열 변환
/// ex)
/// listFromIterable<String>(strings); // ['a', 'b', 'c']
/// listFromIterable<Model>(null); // []
///```
List<T> listFromIterable<T>(Iterable<dynamic>? objects) {
  return objects != null ? List<T>.from(objects) : [];
}

/// **@Deprecated**
/// * 백엔드에서 Json형 String방식으로 보내고 프론트에서 JsonDecode로 받으면 쓸 필요가 없는 메서드이다.
///
/// Fcm으로 data를 받으면 모두 string값으로 전달된다.
/// 모든 필드가 string이면 모델 변환시 맞지 않을 수 있기 때문에
/// 그중 int형으로 변환 가능한것은 int로 변환하여 준다.
@Deprecated('백엔드에서 Json형 String방식으로 보내고 프론트에서 JsonDecode로 받으면 쓸 필요가 없는 메서드이다.')
Map<String, dynamic> convertFcmMapToDynamic(Map<String, dynamic> stringMap) {
  return stringMap.map((key, value) {
    if (value == null) {
      return MapEntry(key, value);
    } else {
      int? intValue = int.tryParse(value);
      return MapEntry(key, intValue ?? value);
    }
  });
}

///
///
/// binary to boolean
/// 숫자를 참거짓으로 바꿔줌
///
/// **ex)**
/// * 0 -> false
/// * 1 -> true
/// * null -> false
///
bool btb(int? binary) {
  return (binary ?? 0) == 1;
}

/// null 체크하여 null이 아니면 [result]를 반환한다.
/// [result]가 없으면 null체크한 객체를 반환
///
/// **params**
/// * [willChecked] 널체크할 객체
/// * [result] null이 아니면 반환할 객체
///
T? nullCheck<T>(dynamic willChecked, [T? result]) {
  return willChecked == null ? null : result ?? willChecked;
}
