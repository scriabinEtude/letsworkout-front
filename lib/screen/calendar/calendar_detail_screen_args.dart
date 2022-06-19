import 'package:letsworkout/bloc/calendar/calendar_cubit.dart';

class CalendarDetailScreenArgs {
  final CalendarCubit calendarCubit;
  final DateTime date;

  CalendarDetailScreenArgs({
    required this.calendarCubit,
    required this.date,
  });
}
