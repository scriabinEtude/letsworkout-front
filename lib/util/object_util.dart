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

///```
///
/// Fcm으로 data를 받으면 모두 string값으로 전달된다.
/// 모든 필드가 string이면 모델 변환시 맞지 않을 수 있기 때문에
/// 그중 int형으로 변환 가능한것은 int로 변환하여 준다.
///```
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
