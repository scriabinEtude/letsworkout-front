import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/workout.dart';

class WorkoutState {
  final LoadingState loading;
  final Workout? workout;
  final bool initial;
  final List<Comment> comments;

  WorkoutState({
    this.workout,
    this.loading = LoadingState.init,
    this.initial = true,
    required this.comments,
  });

  WorkoutState copyWith({
    Workout? workout,
    LoadingState? loading,
    bool? initial,
    List<Comment>? comments,
  }) =>
      WorkoutState(
        workout: workout ?? this.workout,
        loading: loading ?? this.loading,
        initial: initial ?? this.initial,
        comments: comments ?? this.comments,
      );
}
