class AppState {
  final String? message;

  AppState({
    this.message,
  });

  AppState copyWith({
    String? message,
  }) {
    return AppState(
      message: message ?? this.message,
    );
  }
}
