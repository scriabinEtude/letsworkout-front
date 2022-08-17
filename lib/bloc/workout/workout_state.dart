import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';

class WorkoutState {
  final LoadingState loading;
  Feed? feedActive;
  final bool initial;
  final List<Comment> comments;

  WorkoutState({
    this.feedActive,
    this.loading = LoadingState.init,
    this.initial = true,
    required this.comments,
  });

  WorkoutState setFeedNull() {
    feedActive = null;
    return copyWith();
  }

  WorkoutState copyWith({
    Feed? feedActive,
    LoadingState? loading,
    bool? initial,
    List<Comment>? comments,
  }) =>
      WorkoutState(
        feedActive: feedActive ?? this.feedActive,
        loading: loading ?? this.loading,
        initial: initial ?? this.initial,
        comments: comments ?? this.comments,
      );
}
