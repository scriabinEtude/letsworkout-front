import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/calendar/calendar_cubit.dart';
import 'package:letsworkout/bloc/calendar/calendar_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/calendar/calendar_detail_screen_args.dart';
import 'package:letsworkout/util/date_util.dart';
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
  late final CalendarCubit _calendarCubit;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  @override
  void initState() {
    _calendarCubit = CalendarCubit(user: widget.user);
    _firstDay = DateTime.parse(widget.user.createdAt!);
    _lastDay =
        DateTime.parse(widget.user.createdAt!).add(const Duration(days: 100));
    super.initState();

    // 이번달 캘린더 정보 불러오기
    Future.delayed(Duration.zero, () {
      _calendarCubit.getFeedsMonth(_focusedDay);
    });
  }

  @override
  void dispose() {
    _calendarCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        header(),
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
    );
  }

  Widget header() {
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
}
