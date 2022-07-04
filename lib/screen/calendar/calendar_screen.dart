import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/calendar/calendar_cubit.dart';
import 'package:letsworkout/bloc/calendar/calendar_state.dart';
import 'package:letsworkout/bloc/follow/follow_cubit.dart';
import 'package:letsworkout/bloc/follow/follow_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/calendar/calendar_detail_screen_args.dart';
import 'package:letsworkout/screen/follow/follow_list_screen_args.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final FollowCubit _followCubit;
  late final CalendarCubit _calendarCubit;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  @override
  void initState() {
    initCalendar();
    initFollow();
    super.initState();
  }

  @override
  void dispose() {
    _calendarCubit.close();
    super.dispose();
  }

  Future initCalendar() async {
    // 달력 세팅
    _calendarCubit = CalendarCubit(user: widget.user);
    _firstDay = DateTime.parse(widget.user.createdAt!);
    _lastDay = DateTime.now();

    // 이번달 캘린더 정보 불러오기
    _calendarCubit.getFeedsMonth(_focusedDay);
  }

  Future initFollow() async {
    _followCubit = FollowCubit(user: widget.user);

    // 팔로우 숫자 불러오기
    await _followCubit.loadFollowCount();
    await _followCubit.isFollow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.user.id! == AppBloc.userCubit.user!.id!
          ? null
          : AppBar(
              title: Text(widget.user.name!),
              centerTitle: true,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: BlocBuilder<FollowCubit, FollowState>(
                bloc: _followCubit,
                builder: (context, state) {
                  return profileSummary(state);
                }),
          ),
          calendarHeader(),
          BlocBuilder<CalendarCubit, CalendarState>(
              bloc: _calendarCubit,
              builder: (contex, state) {
                return TableCalendar<Feed>(
                  locale: 'ko_KR',
                  focusedDay: _focusedDay,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  headerVisible: false,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  selectedDayPredicate: (selectedDay) {
                    return _selectedDay == selectedDay;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    Navigator.pushNamed(
                      context,
                      Routes.calendarDetailScreen,
                      arguments: CalendarDetailScreenArgs(
                          calendarCubit: _calendarCubit, date: selectedDay),
                    );
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _calendarCubit.getFeedsMonth(focusedDay);
                    });
                  },
                  eventLoader: (DateTime day) {
                    return state.feeds[getYearMonthDay(day)] ?? [];
                  },
                );
              }),
        ],
      ),
    );
  }

  Widget calendarHeader() {
    return Container(
      height: 30,
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_focusedDay.month}월',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget profileSummary(FollowState state) {
    return Column(
      children: [
        Row(
          children: [
            Avatar(
              size: 40,
              image: widget.user.profileImage,
            ),
            Expanded(
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.followListScreen,
                        arguments: FollowListScreenArgs(
                          followCubit: _followCubit,
                        )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('${state.followersCnt}'),
                        const Text('Followers'),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        Text('${state.followingCnt}'),
                        const Text('Following'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        if (state.user.id != AppBloc.userCubit.user!.id &&
            state.loading == LoadingState.done)
          Row(
            children: [
              InkWell(
                onTap: () {
                  state.isFollow
                      ? _followCubit.unFollow()
                      : _followCubit.follow();
                },
                child: Container(
                  width: 200,
                  height: 30,
                  color: state.isFollow ? Colors.grey : Colors.blue,
                  child: const Center(
                    child: Text('follow'),
                  ),
                ),
              )
            ],
          )
      ],
    );
  }
}
