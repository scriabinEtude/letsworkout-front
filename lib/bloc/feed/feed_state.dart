import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed_active.dart';

class FeedState {
  final LoadingState loading;
  final List<FeedActive> feedActives;

  FeedState({
    this.loading = LoadingState.init,
    required this.feedActives,
  });

  FeedState copyWith({
    LoadingState? loading,
    List<FeedActive>? feedActives,
  }) =>
      FeedState(
        loading: loading ?? this.loading,
        feedActives: feedActives ?? this.feedActives,
      );
}
