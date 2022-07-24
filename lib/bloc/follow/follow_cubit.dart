import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/follow/follow_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/friend_repository.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit({required User user})
      : super(FollowState(
          user: user,
          followers: [],
          following: [],
        ));

  final FriendRepository _friendRepository = FriendRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future loadFollowCount() async {
    try {
      setLoading(LoadingState.loading);
      Map result =
          await _friendRepository.getFollowCount(userId: state.user.userId!);

      emit(state.copyWith(
        loading: LoadingState.done,
        followersCnt: result['followers'] ?? 0,
        followingCnt: result['following'] ?? 0,
      ));
    } catch (e) {
      print(e);
      setLoading(LoadingState.done);
    }
  }

  Future loadFollows() async {
    try {
      setLoading(LoadingState.loading);
      Map result =
          await _friendRepository.getFollows(userId: state.user.userId!);

      emit(state.copyWith(
        loading: LoadingState.done,
        followers: User.fromJsonList(result['followers']),
        following: User.fromJsonList(result['following']),
      ));
    } catch (e) {
      print(e);
      setLoading(LoadingState.done);
    }
  }

  Future follow() async {
    try {
      // 주제 구독

      //
      setLoading(LoadingState.loading);
      bool success = await _friendRepository.follow(
        myId: AppBloc.userCubit.user!.userId!,
        followId: state.user.userId!,
      );

      if (success) {
        emit(state.copyWith(
          isFollow: true,
          followersCnt: state.followersCnt + 1,
        ));
      }
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future unFollow() async {
    try {
      setLoading(LoadingState.loading);
      bool success = await _friendRepository.unFollow(
        myId: AppBloc.userCubit.user!.userId!,
        followId: state.user.userId!,
      );

      if (success) {
        emit(state.copyWith(
          isFollow: false,
          followersCnt: state.followersCnt - 1,
        ));
      }
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future isFollow() async {
    try {
      setLoading(LoadingState.loading);

      emit(state.copyWith(
        loading: LoadingState.done,
        isFollow: await _friendRepository.isFollow(
          myId: AppBloc.userCubit.user!.userId!,
          followId: state.user.userId!,
        ),
      ));
    } catch (e) {
      print(e);
      setLoading(LoadingState.done);
    }
  }
}
