import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/model/feed.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(CalendarState(feeds: [
          Feed(
              feedType: 0,
              userName: "임한결",
              contents: "벤치프레스",
              tag: "scriabinEtude",
              createdAt: "13:00"),
          Feed(
              feedType: 1,
              userName: "임한결",
              contents: "벤치프레스",
              tag: "scriabinEtude",
              createdAt: "13:00"),
          Feed(
              feedType: 0,
              userName: "임한결",
              contents: "벤치프레스",
              tag: "scriabinEtude",
              createdAt: "13:00"),
        ]));
}
