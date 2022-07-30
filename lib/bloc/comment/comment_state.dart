import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';

class CommentState {
  final LoadingState loading;
  final Feed feed;
  final List<Comment> comments;

  CommentState({
    this.loading = LoadingState.init,
    required this.feed,
    required this.comments,
  });

  CommentState copyWith({
    LoadingState? loading,
    Feed? feed,
    List<Comment>? comments,
  }) =>
      CommentState(
        loading: loading ?? this.loading,
        feed: feed ?? this.feed,
        comments: comments ?? this.comments,
      );
}
