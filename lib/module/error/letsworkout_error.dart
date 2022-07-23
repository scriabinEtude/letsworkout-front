/// The operation was not allowed by the object.
///
/// This [Error] is thrown when an instance cannot implement one of the methods
/// in its signature.
@pragma("vm:entry-point")
class LetsworkoutError extends Error {
  final String? message;
  dynamic e;

  @pragma("vm:entry-point")
  LetsworkoutError(String this.message, [dynamic e]);
  @override
  String toString() => "LetsworkoutError: $message ${e?.toString()}";
}
