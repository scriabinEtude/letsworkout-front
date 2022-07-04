import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/diet.dart';

class DietState {
  final Diet? diet;
  final LoadingState loading;

  DietState({
    this.diet,
    this.loading = LoadingState.init,
  });

  DietState copyWith({
    Diet? diet,
    LoadingState? loading,
  }) =>
      DietState(
        diet: diet ?? this.diet,
        loading: loading ?? this.loading,
      );
}
