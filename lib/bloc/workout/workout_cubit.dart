import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/workout/workout_state.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/repository/workout_repository.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:letsworkout/util/widget_util.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit()
      : super(WorkoutState(
          comments: [],
        ));

  final _workoutRepository = WorkoutRepository();

  bool get isNotWorkoutStart =>
      state.workout == null ||
      state.workout?.workoutType == WorkoutType.none.index ||
      state.workout?.workoutType == WorkoutType.end.index;

  bool get isWorkoutStart => !isNotWorkoutStart;

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<Workout?> loadData() async {
    setLoading(LoadingState.loading);
    if (!state.initial) return state.workout;
    try {
      Workout workout = Preferences.workoutGet();

      if (workout.workoutType == WorkoutType.none.index) {
        emit(state.copyWith(initial: false));
        return state.workout;
      } else if (workout.workoutType == WorkoutType.working.index) {
        Workout workoutFilledData = await _workoutRepository.getWorkout(
          workoutId: workout.workoutId!,
          feedId: workout.feedId!,
        );
        emit(state.copyWith(
          initial: false,
          workout: workoutFilledData,
        ));
        return workoutFilledData;
      }
    } catch (e) {
      print(e);
    } finally {
      setLoading(LoadingState.done);
    }
  }

  Future<Workout?> workoutStart() async {
    try {
      loadingShow();

      Workout workout = Workout(
        userId: AppBloc.userCubit.user!.userId,
        workoutType: WorkoutType.working.index,
        time: mysqlDateTimeFormat(DateTime.now()),
      );

      Map<String, dynamic> ids = await _workoutRepository.postWorkout(
          workout, AppBloc.userCubit.user!);

      workout = workout.copyWith(
        workoutId: ids['workout_id'],
        feedId: ids['feed_id'],
      );

      emit(state.copyWith(workout: workout));
      await Preferences.workoutSet(workout);
      return workout;
    } catch (e) {
      print(e);
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
          workout: state.workout?.copyWith(
        description: description,
        images: fileActions,
      )));
    } catch (e) {
      print(e);
    } finally {
      loadingHide();
    }
  }

  Future<Workout> workoutSave({
    required String description,
    required FileActions fileActions,
  }) async {
    loadingShow();

    Workout workout = state.workout!.copyWith(
      description: description,
      images: fileActions,
    );
    try {
      await workout.images?.uploadInsertFiles(BucketPath.workout);
      await _workoutRepository.patchWorkout(workout);
      workout.images?.init();

      emit(state.copyWith(workout: workout));
      return workout;
    } catch (e) {
      print(e);
      return workout;
    } finally {
      loadingHide();
    }
  }

  Future<Workout> workoutEnd({
    required String description,
    required FileActions fileActions,
  }) async {
    try {
      loadingShow();
      await workoutSave(
        description: description,
        fileActions: fileActions,
      );

      Workout workout = state.workout!.copyWith(
        workoutType: WorkoutType.end.index,
        endTime: mysqlDateTimeFormat(DateTime.now()),
      );

      await _workoutRepository.endWorkout(
        workout,
        AppBloc.userCubit.user!,
      );
      await Preferences.workoutRemove();

      emit(state.copyWith(workout: Workout.init()));
      AppBloc.feedCubit.resetComment();
      return Workout.init();
    } catch (e) {
      print(e);
      return Workout.init();
    } finally {
      loadingHide();
    }
  }

  addLikes(int add) {
    if (state.workout == null) return;
    emit(state.copyWith(
        workout: state.workout!.copyWith(
      likes: state.workout!.likes! + add,
    )));
  }
}
