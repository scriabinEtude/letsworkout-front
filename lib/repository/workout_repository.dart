import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';

class WorkoutRepository {
  String _getUrl(String url) {
    return '/workout$url';
  }

  Future<int?> postWorkout(Workout workout, User user) async {
    try {
      Response result = await api.post(_getUrl('/'), data: {
        'workout': workout.toJson(),
        'user': user.toJson(),
      });

      if (result.statusCode != 200) return null;
      return result.data['id'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> endWorkout(Workout workout, User user) async {
    try {
      Response result = await api.put(_getUrl('/'), data: {
        'workout': workout.toJson(),
        'user': user.toJson(),
      });
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> patchWorkout(Workout workout) async {
    try {
      Response result = await api.patch(_getUrl('/'), data: workout.toJson());
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
