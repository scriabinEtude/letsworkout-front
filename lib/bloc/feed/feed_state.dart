import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/model/user.dart';

class FeedState {
  final LoadingState loading;
  final User user;
  final List<FeedActive> feedActives;

  FeedState({
    this.loading = LoadingState.init,
    required this.user,
    required this.feedActives,
  });

  FeedState copyWith({
    LoadingState? loading,
    User? user,
    List<FeedActive>? feedActives,
  }) =>
      FeedState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        feedActives: feedActives ?? this.feedActives,
      );
}
