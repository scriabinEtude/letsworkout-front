import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/repository/feed_repository.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit()
      : super(
          FeedState(
            feedActives: [],
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
}
