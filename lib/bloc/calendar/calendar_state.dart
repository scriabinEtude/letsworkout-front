import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';

class CalendarState {
  final LoadingState loading;
  final User user;
  final Map<String, List<Feed>> feeds;
  final List<dynamic> feedOneDay;

  CalendarState({
    this.loading = LoadingState.init,
    required this.user,
    required this.feeds,
    required this.feedOneDay,
  });

  CalendarState copyWith({
    LoadingState? loading,
    User? user,
    Map<String, List<Feed>>? feeds,
    List<dynamic>? feedOneDay,
  }) =>
      CalendarState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        feeds: feeds ?? this.feeds,
        feedOneDay: feedOneDay ?? this.feedOneDay,
      );
}
