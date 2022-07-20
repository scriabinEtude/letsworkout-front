import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/workout.dart';

class WorkoutState {
  final LoadingState loading;
  final Workout? workout;
  final bool initial;

  WorkoutState({
    this.workout,
    this.loading = LoadingState.init,
    this.initial = true,
  });

  WorkoutState copyWith(
          {Workout? workout, LoadingState? loading, bool? initial}) =>
      WorkoutState(
        workout: workout ?? this.workout,
        loading: loading ?? this.loading,
        initial: initial ?? this.initial,
      );
}
