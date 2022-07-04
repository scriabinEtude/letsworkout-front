import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/calendar/calendar_cubit.dart';
import 'package:letsworkout/bloc/calendar/calendar_state.dart';
import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/util/date_util.dart';

class CalendarDetailScreen extends StatefulWidget {
  const CalendarDetailScreen({
    Key? key,
    required this.calendarCubit,
    required this.date,
  }) : super(key: key);
  final CalendarCubit calendarCubit;
  final DateTime date;

  @override
  State<CalendarDetailScreen> createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  @override
  void initState() {
    widget.calendarCubit.getFeedsDay(widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(getYearMonthDay(widget.date)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<CalendarCubit, CalendarState>(
          bloc: widget.calendarCubit,
          builder: (context, state) {
            return ListView(
              children:
                  state.feedOneDay.map((feed) => feedWidget(feed)).toList(),
            );
          }),
    );
  }

  Widget feedWidget(dynamic feed) {
    ActType type = ActType.values[feed.actType];

    return Container(
        child: Column(
      children: [
        if (feed.images?.isNotEmpty == true)
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (feed.images as List<String>)
                  .map((image) => Image.network(
                        image,
                      ))
                  .toList(),
            ),
          ),
        Text(type.title),
        Text('${feed.time} ${feed.description}'),
        if (AppBloc.userCubit.user!.id! == feed.userId)
          ElevatedButton(
            onPressed: () async {
              OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                message: '기록을 삭제하시겠습니까?',
                okLabel: '삭제',
                cancelLabel: '취소',
              );
              if (result == OkCancelResult.ok) {
                await widget.calendarCubit.deleteFeed(feed, widget.date);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('삭제'),
          ),
      ],
    ));
  }
}
