import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/workout/workout_state.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/repository/feed_repository.dart';
import 'package:letsworkout/repository/workout_repository.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:letsworkout/util/widget_util.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit()
      : super(WorkoutState(
          comments: [],
        ));

  final _workoutRepository = WorkoutRepository();
  final _feedRepository = FeedRepository();

  bool get isNotWorkoutStart =>
      state.feedActive == null ||
      state.feedActive?.workout == null ||
      state.feedActive?.workout?.workoutType == WorkoutType.none.index ||
      state.feedActive?.workout?.workoutType == WorkoutType.end.index;

  bool get isWorkoutStart => !isNotWorkoutStart;

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<Feed?> loadData() async {
    setLoading(LoadingState.loading);
    try {
      Feed? feed = Preferences.workoutGet();

      if (feed != null) {
        feed = await _feedRepository.getFeed(feedId: feed.feedId!);
        emit(state.copyWith(
          feedActive: feed,
        ));
      }

      return feed;
    } catch (e) {
      print(e);
      return null;
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future<Feed?> workoutStart() async {
    try {
      loadingShow();

      Feed feedActive = Feed(
        user: AppBloc.userCubit.user!,
        workout: Workout(
          workoutType: WorkoutType.working.index,
        ),
        time: mysqlDateTimeFormat(DateTime.now()),
      );

      feedActive = feedActive.copyWith(
        feedId: await _workoutRepository.postWorkout(feedActive),
      );

      emit(state.copyWith(feedActive: feedActive));
      await Preferences.workoutSet(feedActive);
      return feedActive;
    } catch (e) {
      print(e);
      return null;
    } finally {
      loadingHide();
    }
  }

  Future workoutSaveLocal({
    required String description,
    required FileActions fileActions,
  }) async {
    try {
      loadingShow();

      emit(state.copyWith(
          feedActive: state.feedActive?.copyWith(
        description: description,
        images: fileActions,
      )));
    } catch (e) {
      print(e);
    } finally {
      loadingHide();
    }
  }

  Future<Feed> workoutSave({
    required String description,
    required FileActions fileActions,
  }) async {
    loadingShow();

    Feed feed = state.feedActive!.copyWith(
      description: description,
      images: fileActions,
    );
    try {
      await feed.images?.uploadInsertFiles(BucketPath.workout);
      await _workoutRepository.patchWorkout(feed);
      feed.images?.init();

      emit(state.copyWith(feedActive: feed));
      return feed;
    } catch (e) {
      print(e);
      return feed;
    } finally {
      loadingHide();
    }
  }

  Future workoutEnd({
    required String description,
    required FileActions fileActions,
  }) async {
    try {
      loadingShow();
      await workoutSave(
        description: description,
        fileActions: fileActions,
      );

      Feed feed = state.feedActive!.copyWith(
        workout: state.feedActive!.workout!.copyWith(
          workoutType: WorkoutType.end.index,
          endTime: mysqlDateTimeFormat(DateTime.now()),
        ),
      );

      await _workoutRepository.endWorkout(feed);
      await Preferences.workoutRemove();

      emit(state.setFeedNull());
      AppBloc.feedCubit.resetComment();
      return null;
    } catch (e) {
      print(e);
      return null;
    } finally {
      loadingHide();
    }
  }

  addLikes(int add) {
    if (state.feedActive == null) return;
    emit(state.copyWith(
        feedActive: state.feedActive!.copyWith(
      likes: state.feedActive!.likes! + add,
    )));
  }
}
