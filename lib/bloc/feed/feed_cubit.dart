import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/like.dart';
import 'package:letsworkout/repository/feed_repository.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({Feed? feed})
      : super(
          FeedState(
            feeds: [],
            feed: feed,
            comments: [],
          ),
        );
  final FeedRepository _feedRepository = FeedRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  void addFeed(Feed feed) async {
    emit(state.copyWith(
      feeds: [
        feed,
        ...state.feeds,
      ],
    ));
  }

  void removeFeed(Feed feedWillRemove) async {
    state.feeds.removeWhere((feed) => feed.feedId == feedWillRemove.feedId);

    emit(state.copyWith());
  }

  Future getFeedActives() async {
    try {
      setLoading(LoadingState.loading);
      emit(state.copyWith(
        feeds: await _feedRepository.getFeedActives(
          userId: AppBloc.userCubit.user!.userId!,
        ),
      ));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future toggleLike() async {
    state.feed!.isLiked! ? await _unLike() : await _like();
  }

  Future _like() async {
    try {
      _setIsLiked(
        feedId: state.feed!.feedId!,
        isLiked: true,
      );

      await _feedRepository.like(
        feedId: state.feed!.feedId!,
        user: AppBloc.userCubit.user!,
        feedFcmToken: state.feed!.user!.fcmToken!,
      );
    } catch (e) {
      print(e);
      _setIsLiked(
        feedId: state.feed!.feedId!,
        isLiked: false,
      );
    }
  }

  Future _unLike() async {
    try {
      _setIsLiked(
        feedId: state.feed!.feedId!,
        isLiked: false,
      );

      await _feedRepository.unLike(
        feedId: state.feed!.feedId!,
        user: AppBloc.userCubit.user!,
        feedFcmToken: state.feed!.user!.fcmToken!,
      );
    } catch (e) {
      print(e);
      _setIsLiked(
        feedId: state.feed!.feedId!,
        isLiked: true,
      );
    }
  }

  void _setIsLiked({required int feedId, required bool isLiked}) {
    AppBloc.feedCubit.setIsLikeInActives(feedId: feedId, isLiked: isLiked);
    state.feed!.isLiked = isLiked;
    emit(state.copyWith());
    // emit(state.copyWith(
    //   feed: state.feed!.copyWith(
    //     isLiked: isLiked,
    //   ),
    // ));
  }

  void setIsLikeInActives({required int feedId, required bool isLiked}) {
    state.feeds.firstWhere((active) => active.feedId == feedId).isLiked =
        isLiked;
  }

  void resetComment() {
    emit(state.copyWith(comments: []));
  }

  Future commentInsert({
    required int depth,
    required int? parentId,
    required String comment,
  }) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.comment(
        comment: Comment(
          feedId: state.feed!.feedId!,
          depth: depth,
          parentId: parentId,
          comment: comment,
          user: AppBloc.userCubit.user!,
        ),
        feedFcmToken: state.feed!.user!.fcmToken!,
        isMine: false,
      );

      await commentGet(feedId: state.feed!.feedId!);
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future workoutingCommentInsert({
    required int feedId,
    required int depth,
    required int? parentId,
    required String comment,
  }) async {
    Comment commentModel = Comment(
      feedId: feedId,
      depth: depth,
      parentId: parentId,
      comment: comment,
      user: AppBloc.userCubit.user!,
    );

    try {
      _feedRepository.comment(
        comment: commentModel,
        feedFcmToken: AppBloc.userCubit.user!.fcmToken!,
        isMine: true,
      );
    } catch (e) {
      print(e);
    }
  }

  Future commentDelete({required Comment comment}) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.commentDelete(
        comment: comment,
        feedFcmToken: state.feed!.user!.fcmToken!,
      );

      await commentGet(
        feedId: state.feed!.feedId!,
      );
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future commentGet({required int? feedId}) async {
    if (feedId == null) return;
    try {
      setLoading(LoadingState.loading);

      emit(state.copyWith(
          comments: await _feedRepository.getComments(
        feedId: feedId,
        userId: AppBloc.userCubit.user!.userId!,
      )));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future toggleCommentLike(Comment comment) async {
    comment.isLiked!
        ? await _commentUnLike(comment.feedCommentId!)
        : await _commentLike(comment.feedCommentId!);
  }

  Future _commentLike(int commentId) async {
    try {
      _setCommentIsLiked(
        commentId: commentId,
        isLiked: true,
      );

      await _feedRepository.commentLike(
        commentId: commentId,
        userId: AppBloc.userCubit.user!.userId!,
      );
    } catch (e) {
      print(e);
      _setCommentIsLiked(
        commentId: commentId,
        isLiked: false,
      );
    }
  }

  Future _commentUnLike(int commentId) async {
    try {
      _setCommentIsLiked(
        commentId: commentId,
        isLiked: false,
      );

      await _feedRepository.commentUnLike(
        commentId: commentId,
        userId: AppBloc.userCubit.user!.userId!,
      );
    } catch (e) {
      print(e);
      _setCommentIsLiked(
        commentId: commentId,
        isLiked: true,
      );
    }
  }

  void _setCommentIsLiked({required int commentId, required bool isLiked}) {
    Comment c = state.comments.firstWhere((c) => c.feedCommentId == commentId);
    c.isLiked = isLiked;
    c.likes = c.likes! + (isLiked ? 1 : -1);

    emit(state.copyWith());
  }

  void addCommentFromFcm(Comment comment) {
    if (AppBloc.workoutCubit.isNotWorkoutStart) return;
    if (AppBloc.workoutCubit.state.workout?.feedId != comment.feedId) return;

    state.comments.insert(0, comment);
    emit(state.copyWith());
  }

  void removeCommentFromFcm(Comment willRemove) {
    if (AppBloc.workoutCubit.isNotWorkoutStart) return;
    if (AppBloc.workoutCubit.state.workout?.feedId != willRemove.feedId) return;

    state.comments.removeWhere(
        (comment) => comment.feedCommentId == willRemove.feedCommentId);
    emit(state.copyWith());
  }

  void addLikeFromFcm(Like like) {
    if (AppBloc.workoutCubit.isNotWorkoutStart) return;
    if (AppBloc.workoutCubit.state.workout?.feedId != like.feedId) return;

    AppBloc.workoutCubit.addLikes(1);
  }

  void removeLikeFromFcm(Like like) {
    if (AppBloc.workoutCubit.isNotWorkoutStart) return;
    if (AppBloc.workoutCubit.state.workout?.feedId != like.feedId) return;

    AppBloc.workoutCubit.addLikes(-1);
  }
}
