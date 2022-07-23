import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed_active.dart';

class FeedState {
  final LoadingState loading;
  final List<FeedActive> feedActives;
  final FeedActive? feedActive;
  final List<Comment> comments;

  FeedState({
    this.loading = LoadingState.init,
    required this.feedActives,
    this.feedActive,
    required this.comments,
  });

  FeedState copyWith({
    LoadingState? loading,
    List<FeedActive>? feedActives,
    FeedActive? feedActive,
    List<Comment>? comments,
  }) =>
      FeedState(
        loading: loading ?? this.loading,
        feedActives: feedActives ?? this.feedActives,
        feedActive: feedActive ?? this.feedActive,
        comments: comments ?? this.comments,
      );
}
