import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/repository/feed_repository.dart';

class FeedCubit<T extends Feed> extends Cubit<FeedState> {
  FeedCubit({T? feed})
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

  void addFeed(T feed) async {
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
        userId: AppBloc.userCubit.user!.userId!,
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
        userId: AppBloc.userCubit.user!.userId!,
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

  Future commentInsert({
    required int depth,
    required int? parentId,
    required String comment,
  }) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.comment(
        userId: AppBloc.userCubit.user!.userId!,
        feedId: state.feed!.feedId!,
        depth: depth,
        parentId: parentId,
        comment: comment,
      );

      await commentGet(feedId: state.feed!.feedId!);
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future commentDelete({
    required Comment comment,
  }) async {
    try {
      setLoading(LoadingState.loading);
      await _feedRepository.commentDelete(
        commentId: comment.feedCommentId!,
        feedId: comment.feedId!,
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

  Future toggleCommentLike({required Comment comment}) async {
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
}
