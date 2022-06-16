import 'package:letsworkout/enum/feed_type.dart';

class CalendarState {
  final bool loading;
  final Map<String, List<FeedType>> events;

  CalendarState({
    this.loading = false,
    required this.events,
  });

  CalendarState copyWith(
    bool? loading,
    Map<String, List<FeedType>>? events,
  ) =>
      CalendarState(
        loading: loading ?? this.loading,
        events: events ?? this.events,
      );
}
