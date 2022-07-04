import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/follow/follow_cubit.dart';
import 'package:letsworkout/bloc/follow/follow_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/calendar/calendar_screen_args.dart';

class FollowListScreen extends StatefulWidget {
  const FollowListScreen({
    Key? key,
    required this.followCubit,
  }) : super(key: key);
  final FollowCubit followCubit;

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final PageController _pageController = PageController();
  double _barLeft = 0;

  @override
  void initState() {
    initFollow();
    super.initState();
    _pageController.addListener(() {
      _barLeft = _pageController.offset / 2;
      setState(() {});
    });
  }

  Future initFollow() async {
    await widget.followCubit.loadFollows();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: Stack(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () => _pageController.jumpToPage(0),
                          child: const Text('followers')),
                      InkWell(
                          onTap: () => _pageController.jumpToPage(1),
                          child: const Text('following')),
                    ],
                  ),
                ),
                Positioned(
                  left: _barLeft,
                  top: 59,
                  child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: const BoxDecoration(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FollowCubit, FollowState>(
                bloc: widget.followCubit,
                builder: (context, state) {
                  return PageView(
                    controller: _pageController,
                    children: [
                      Followers(state: state),
                      Following(state: state),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Followers extends StatelessWidget {
  const Followers({
    Key? key,
    required this.state,
  }) : super(key: key);
  final FollowState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: ListView(
        children: state.followers
            .map((follower) => followerWidget(context, follower))
            .toList(),
      ),
    );
  }

  Widget followerWidget(BuildContext context, User follower) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.calendarScreen,
            arguments: CalendarScreenArgs(user: follower));
      },
      child: Container(
        height: 100,
        color: Colors.white,
        child: Center(
          child: Row(
            children: [
              Text(follower.name!),
              Text(follower.tag!),
            ],
          ),
        ),
      ),
    );
  }
}

class Following extends StatelessWidget {
  const Following({
    Key? key,
    required this.state,
  }) : super(key: key);
  final FollowState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: ListView(
        children: state.following
            .map((follow) => followWidget(context, follow))
            .toList(),
      ),
    );
  }

  Widget followWidget(BuildContext context, User follower) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.calendarScreen,
            arguments: CalendarScreenArgs(user: follower));
      },
      child: Container(
        height: 100,
        color: Colors.white,
        child: Center(
          child: Row(
            children: [
              Text(follower.name!),
              Text(follower.tag!),
            ],
          ),
        ),
      ),
    );
  }
}
