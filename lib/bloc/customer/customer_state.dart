import 'package:letsworkout/enum/loading_state.dart';

class CustomerState {
  final LoadingState loading;

  CustomerState({
    this.loading = LoadingState.init,
  });

  CustomerState copyWith({
    LoadingState? loading,
  }) =>
      CustomerState(
        loading: loading ?? this.loading,
      );
}
