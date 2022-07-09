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
