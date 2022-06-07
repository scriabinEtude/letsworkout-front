import 'package:letsworkout/model/feed.dart';

class FeedState {
  final bool loading;
  final List<Feed> feeds;

  FeedState({
    this.loading = false,
    required this.feeds,
  });

  FeedState copyWith(
    bool? loading,
    List<Feed>? feeds,
  ) =>
      FeedState(
        loading: loading ?? this.loading,
        feeds: feeds ?? this.feeds,
      );
}
