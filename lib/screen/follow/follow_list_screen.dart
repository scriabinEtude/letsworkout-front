import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/follow/follow_cubit.dart';
import 'package:letsworkout/bloc/follow/follow_state.dart';

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

  @override
  void initState() {
    initFollow();
    super.initState();
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
      body: BlocBuilder<FollowCubit, FollowState>(
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
    return Container();
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
    return Container();
  }
}
