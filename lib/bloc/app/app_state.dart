import 'package:letsworkout/enum/app_state_type.dart';

class AppState {
  final AppStateType type;
  final String? message;

  AppState({
    required this.type,
    this.message,
  });

  AppState copyWith({
    AppStateType? type,
    String? message,
  }) {
    return AppState(
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }
}
