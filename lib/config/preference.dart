import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/repository/workout_repository.dart';
import 'package:letsworkout/util/widget_util.dart';
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

  static T? getObject<T>(String key,
      [T? Function(Map<String, dynamic>)? parser]) {
    String? objStr = instance!.getString(key);
    if (objStr == null || objStr == "null" || objStr.isEmpty) {
      return null;
    }

    try {
      return parser == null ? jsonDecode(objStr) : parser(jsonDecode(objStr));
    } catch (e) {
      print(e);
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

  static Feed? workoutGet() {
    return getObject('workout', Feed.fromJson);
  }

  static Future workoutSet(Feed feed) async {
    await setObject('workout', feed);
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
