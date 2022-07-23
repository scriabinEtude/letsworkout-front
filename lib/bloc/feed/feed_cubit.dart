import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/repository/feed_repository.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({FeedActive? feedActive})
      : super(
          FeedState(
            feedActives: [],
            feedActive: feedActive,
            comments: [],
          ),
        );
  final FeedRepository _feedRepository = FeedRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  void addFeedActive(FeedActive feedActive) async {
    emit(state.copyWith(
      feedActives: [
        feedActive,
        ...state.feedActives,
      ],
    ));
  }

  void removeFeedActive(FeedActive feedActive) async {
    state.feedActives
        .removeWhere((feed) => feed.workoutId == feedActive.workoutId);

    emit(state.copyWith());
  }

  Future getFeedActives() async {
    try {
      setLoading(LoadingState.loading);
      emit(state.copyWith(
        feedActives: await _feedRepository.getFeedActives(
          userId: AppBloc.userCubit.user!.id!,
        ),
      ));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future toggleLike() async {
    state.feedActive!.isLiked! ? await _unLike() : await _like();
  }

  Future _like() async {
    try {
      _setIsLiked(
        feedId: state.feedActive!.feedId!,
        isLiked: true,
      );

      await _feedRepository.like(
        feedId: state.feedActive!.feedId!,
        userId: AppBloc.userCubit.user!.id!,
      );
    } catch (e) {
      print(e);
      _setIsLiked(
        feedId: state.feedActive!.feedId!,
        isLiked: false,
      );
    }
  }

  Future _unLike() async {
    try {
      _setIsLiked(
        feedId: state.feedActive!.feedId!,
        isLiked: false,
      );

      await _feedRepository.unLike(
        feedId: state.feedActive!.feedId!,
        userId: AppBloc.userCubit.user!.id!,
      );
    } catch (e) {
      print(e);
      _setIsLiked(
        feedId: state.feedActive!.feedId!,
        isLiked: true,
      );
    }
  }

  void _setIsLiked({required int feedId, required bool isLiked}) {
    AppBloc.feedCubit.setIsLikeInActives(feedId: feedId, isLiked: isLiked);
    emit(state.copyWith(
      feedActive: state.feedActive!.copyWith(
        isLiked: isLiked,
      ),
    ));
  }

  void setIsLikeInActives({required int feedId, required bool isLiked}) {
    state.feedActives
        .firstWhere((active) => active.feedId == feedId,
            orElse: () => FeedActive())
        .isLiked = isLiked;
    emit(state.copyWith());
  }

  Future commentInsert({
    required int depth,
    required int? parentId,
    required String comment,
  }) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.comment(
        userId: AppBloc.userCubit.user!.id!,
        feedId: state.feedActive!.feedId!,
        depth: depth,
        parentId: parentId,
        comment: comment,
      );

      await commentGet(feedId: state.feedActive!.feedId!);
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future commentDelete({
    required int commentId,
  }) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.commentDelete(
        commentId: commentId,
      );

      await commentGet(
        feedId: state.feedActive!.feedId!,
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
        userId: AppBloc.userCubit.user!.id!,
      )));
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future toggleCommentLike({required Comment comment}) async {
    comment.isLiked!
        ? await _commentUnLike(comment.id!)
        : await _commentLike(comment.id!);
  }

  Future _commentLike(int commentId) async {
    try {
      _setCommentIsLiked(
        commentId: commentId,
        isLiked: true,
      );

      await _feedRepository.commentLike(
        commentId: commentId,
        userId: AppBloc.userCubit.user!.id!,
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
        userId: AppBloc.userCubit.user!.id!,
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
    Comment c = state.comments.firstWhere((c) => c.id == commentId);
    c.isLiked = isLiked;
    c.likes = c.likes! + (isLiked ? 1 : -1);

    emit(state.copyWith());
  }
}
