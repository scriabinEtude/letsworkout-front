import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/model/user.dart';

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
  late final FeedCubit _feedCubit;

  @override
  void initState() {
    _feedCubit = FeedCubit(user: widget.user);
    super.initState();

    // 실시간 운동중인 feed 불러오기
    _feedCubit.getFeedActives();
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
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.workoutStartScreen),
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[400]!.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Center(child: Text('운동하기')),
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.dietWriteScreen),
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
              ),
            ],
          ),
          BlocBuilder<FeedCubit, FeedState>(
            bloc: _feedCubit,
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

  Widget feedWidget(FeedActive feed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('임한결 @scriabinEtude 운동시작! 14:00'),
          Text('>'),
        ],
      ),
    );
  }
}
