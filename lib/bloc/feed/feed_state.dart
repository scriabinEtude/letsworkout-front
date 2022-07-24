import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';

class FeedState {
  final LoadingState loading;
  final List<Feed> feeds;
  final Feed? feed;
  final List<Comment> comments;

  FeedState({
    this.loading = LoadingState.init,
    required this.feeds,
    this.feed,
    required this.comments,
  });

  FeedState copyWith({
    LoadingState? loading,
    List<Feed>? feeds,
    Feed? feed,
    List<Comment>? comments,
  }) =>
      FeedState(
        loading: loading ?? this.loading,
        feeds: feeds ?? this.feeds,
        feed: feed ?? this.feed,
        comments: comments ?? this.comments,
      );
}
