import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/calendar/calendar_cubit.dart';
import 'package:letsworkout/bloc/calendar/calendar_state.dart';
import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/screen/diet/diet_food_widgets.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:letsworkout/widget/photo_cards.dart';

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
            return SingleChildScrollView(
              child: Column(
                children: state.feedOneDay.map((feed) {
                  ActType type = ActType.values[feed.actType!];

                  switch (type) {
                    case ActType.workout:
                      return workoutWidget(feed);
                    case ActType.diet:
                      return dietWidget(feed);
                  }
                }).toList(),
              ),
            );
          }),
    );
  }

  Widget workoutWidget(Workout workout) {
    return Container();
  }

  Widget dietWidget(Diet diet) {
    return Column(
      children: [
        Text(diet.time!),
        if (diet.images?.isNotEmpty == true)
          PhotoCards(
            images: diet.images!,
            isViewMode: true,
            width: MediaQuery.of(context).size.width,
          ),
        if (diet.foods?.isNotEmpty == true)
          Wrap(
            children: diet.foods!
                .map((food) => FoodTag(food: food, onTap: () {}))
                .toList(),
          ),
        Text('칼로리: ${diet.calorie ?? 0}'),
        Text('탄수화물: ${diet.carbohydrate ?? 0}'),
        Text('단백질: ${diet.protein ?? 0}'),
        Text('지방: ${diet.fat ?? 0}'),
        Text('당: ${diet.sugar ?? 0}'),
        Text('나트륨: ${diet.sodium ?? 0}'),
        Text('${diet.description}'),
        // Text('좋아요: ${diet.likes ?? 0}'),
        // Text('댓글: ${diet.comments ?? 0}'),
        if (AppBloc.userCubit.user!.userId! == diet.userId)
          ElevatedButton(
            onPressed: () async {
              OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                message: '기록을 삭제하시겠습니까?',
                okLabel: '삭제',
                cancelLabel: '취소',
              );
              if (result == OkCancelResult.ok) {
                await widget.calendarCubit.deleteFeed(diet, widget.date);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('삭제'),
          ),
      ],
    );
  }

  Widget feedWidget(Feed feed) {
    ActType type = ActType.values[feed.actType!];

    return Container(
        child: Column(
      children: [
        if (feed.images?.isNotEmpty == true)
          PhotoCards(images: feed.images!, isViewMode: true, width: 100),
        Text(type.title),
        if (AppBloc.userCubit.user!.userId! == feed.userId)
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
