import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';

class WorkoutRepository {
  String _getUrl(String url) {
    return '/workout$url';
  }

  Future<Workout> getWorkout(int workoutId) async {
    try {
      Response result = await api.get(_getUrl('/'), queryParameters: {
        'id': workoutId,
      });

      return Workout.fromJson(result.data);
    } catch (e) {
      print(e);
      throw LetsworkoutError('해당 아이디의 workout이 없습니다 : $workoutId');
    }
  }

  Future<int> postWorkout(Workout workout, User user) async {
    try {
      Response result = await api.post(_getUrl('/'), data: {
        'workout': workout.toJson(),
        'user': user.toJson(),
      });

      return result.data['id'];
    } catch (e) {
      print(e);
      throw LetsworkoutError('workout_id를 받아오지 못했습니다.');
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
