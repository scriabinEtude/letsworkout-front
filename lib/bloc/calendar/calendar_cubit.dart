import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/calendar/calendar_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/feed_repository.dart';
import 'package:letsworkout/util/date_util.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required this.user})
      : super(
          CalendarState(
            user: user,
            feeds: {},
            feedOneDay: [],
          ),
        );
  final User user;

  final FeedRepository _feedRepository = FeedRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future getFeedsMonth(DateTime date) async {
    List<Feed> feeds = await _feedRepository.getFeedsMonth(
      userId: user.userId!,
      yearMonth: getYearMonth(date),
    );

    //feedMap 생성
    Map<String, List<Feed>> feedMap = {};

    for (var feed in feeds) {
      final String date = feed.createdAt!.substring(0, 10);
      if (feedMap.containsKey(date)) {
        feedMap[date]!.add(feed);
      } else {
        feedMap[date] = [feed];
      }
    }

    // state에 업데이트
    feedMap.forEach((date, list) {
      state.feeds[date] = list;
    });

    emit(state.copyWith());
  }

  Future getFeedsDay(DateTime date) async {
    setLoading(LoadingState.init);

    emit(state.copyWith(
      loading: LoadingState.done,
      feedOneDay: await _feedRepository.getFeedsDay(
        userId: user.userId!,
        yearMonthDay: getYearMonthDay(date),
      ),
    ));
  }

  Future deleteFeed(dynamic feed, DateTime date) async {
    setLoading(LoadingState.loading);

    bool success = await _feedRepository.deleteFeed(
      feed: feed,
    );

    if (success) {
      state.feeds[getYearMonthDay(date)]!
          .removeWhere((prev) => prev.feedId == feed.feedId);
      state.feedOneDay.removeWhere((prev) => prev.feedId == feed.feedId);
    }

    setLoading(LoadingState.done);
  }
}
