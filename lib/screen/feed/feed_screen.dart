import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/bloc/workout/workout_cubit.dart';
import 'package:letsworkout/bloc/workout/workout_state.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/feed/feed_detail_screen_args.dart';
import 'package:letsworkout/widget/test_button.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    // 실시간 운동중인 feed 불러오기
    AppBloc.feedCubit.getFeedActives();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              workoutButton(),
              dietButton(),
            ],
          ),
          BlocBuilder<FeedCubit, FeedState>(
            bloc: AppBloc.feedCubit,
            builder: (context, state) {
              return Column(
                children:
                    state.feedActives.map((feed) => feedWidget(feed)).toList(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget workoutButton() {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      bloc: AppBloc.workoutCubit,
      builder: (context, state) {
        Color color;
        String text;

        if (state.workout == null ||
            state.workout!.workoutType == WorkoutType.none.index) {
          color = Colors.lightBlue[400]!.withOpacity(0.5);
          text = "운동하기";
        } else {
          color = Colors.red[100]!.withOpacity(0.5);
          text = "운동중";
        }

        return InkWell(
          onTap: () => Navigator.pushNamed(context, Routes.workoutStartScreen),
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Center(child: Text(text)),
          ),
        );
      },
    );
  }

  Widget dietButton() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.dietWriteScreen),
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber[400]!, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Center(child: Text('식단 등록')),
      ),
    );
  }

  Widget feedWidget(FeedActive feed) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.feedDetailScreen,
        arguments: FeedDetailScreenArgs(
          feedActive: feed,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: feed.images?.listNetworkUrls
                          .map((url) => CachedNetworkImage(
                                imageUrl: url,
                                width: 80,
                                height: 80,
                              ))
                          .toList() ??
                      [],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${feed.name} @${feed.tag} 운동 시작!'),
                const Text('>'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
