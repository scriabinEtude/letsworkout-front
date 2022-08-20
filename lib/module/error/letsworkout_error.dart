import 'package:letsworkout/util/widget_util.dart';

/// The operation was not allowed by the object.
///
/// This [Error] is thrown when an instance cannot implement one of the methods
/// in its signature.
@pragma("vm:entry-point")
class LetsworkoutError extends Error {
  final String? message;
  final bool? display;
  dynamic e;

  @pragma("vm:entry-point")
  LetsworkoutError(String this.message, {this.display = false}) {
    if (display == true && message != null) {
      snack(message!);
    }
  }

  @override
  String toString() => "LetsworkoutError: $message ${e?.toString()}";
}
