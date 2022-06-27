import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/user.dart';

class FollowState {
  final LoadingState loading;
  final User user;
  final int followersCnt;
  final int followingCnt;
  final bool isFollow;
  final List<User> followers;
  final List<User> following;

  FollowState({
    this.loading = LoadingState.init,
    required this.user,
    this.followersCnt = 0,
    this.followingCnt = 0,
    this.isFollow = false,
    required this.followers,
    required this.following,
  });

  FollowState copyWith({
    LoadingState? loading,
    User? user,
    int? followersCnt,
    int? followingCnt,
    bool? isFollow,
    List<User>? followers,
    List<User>? following,
  }) =>
      FollowState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        followersCnt: followersCnt ?? this.followersCnt,
        followingCnt: followingCnt ?? this.followingCnt,
        isFollow: isFollow ?? this.isFollow,
        followers: followers ?? this.followers,
        following: following ?? this.following,
      );
}
