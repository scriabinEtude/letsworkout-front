import 'package:intl/intl.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/repository/workout_repository.dart';
import 'package:letsworkout/util/cubit_util.dart';
import 'package:letsworkout/util/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  static SharedPreferences? instance;
  static final WorkoutRepository workoutRepository = WorkoutRepository();

  static Future<SharedPreferences?> setPreferences() async {
    instance = await SharedPreferences.getInstance();
    return instance;
  }

  //*** common */
  static Future<bool> remove(String key) async {
    return await instance!.remove(key);
  }

  static T? getObject<T>(String key) {
    String? objStr = instance!.getString(key);
    if (objStr == null || objStr == "null" || objStr.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(objStr);
    } catch (e) {
      snack('object decode error');
      return null;
    }
  }

  static Future<bool> setObject(String key, Object? object) async {
    if (object == null) {
      return await instance!.remove(key);
    }

    try {
      return await instance!.setString(key, jsonEncode(object));
    } catch (e) {
      snack('preference set object');
      return false;
    }
  }

  //*** USER */
  static Future<void> userInit() async {
    await remove("user");
  }

  static Future<void> userSet(User user) async {
    await setObject("user", user);
  }

  static User? userGet() {
    var user = getObject('user');
    if (user == null) return null;
    return User.fromJson(user);
  }

  //*** WORKOUT */
  static Future<void> workoutRemove() async {
    await remove('workout');
  }

  static Future<Workout?> workoutStart() async {
    User? me = userGet();
    if (me == null) {
      snack('로그인을 먼저 해주세요');
      return null;
    }

    Workout workout = Workout(
      userId: me.id,
      workoutType: WorkoutType.working.index,
      time: mysqlDateTimeFormat(DateTime.now()),
    );

    int? id = await workoutRepository.postWorkout(workout);
    if (id == null) return null;

    workout = workout.copyWith(id: id);
    await workoutRepository.userActivate(me.id!);
    await setObject('workout', workout);
    return workout;
  }

  static Future<Workout?> workoutEnd() async {
    Workout? workout = workoutGet()?.copyWith(
      workoutType: WorkoutType.end.index,
      endTime: mysqlDateTimeFormat(DateTime.now()),
    );

    if (workout != null) {
      await workoutRepository.userDeactivate(workout.userId!);
      await workoutRepository.endWorkout(workout);
    }

    await workoutRemove();
    return workout;
  }

  static Workout? workoutGet() {
    var workout = getObject('workout');
    if (workout == null) return null;
    return Workout.fromJson(workout);
  }

  static Future<Workout> workoutSet(Workout workout) async {
    await workoutRepository.patchWorkout(workout);
    await setObject('workout', workout);
    return workout;
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
