import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';

class WorkoutRepository {
  String _getUrl(String url) {
    return '/workout$url';
  }

  Future<Workout> getWorkout({
    required int workoutId,
    required int feedId,
  }) async {
    try {
      Response result = await api.get(_getUrl('/'),
          queryParameters: {'workout_id': workoutId, 'feed_id': feedId});

      return Workout.fromJson(result.data);
    } catch (e) {
      print(e);
      throw LetsworkoutError('repo getWorkout : $workoutId $feedId', e);
    }
  }

  Future<Map<String, dynamic>> postWorkout(Workout workout, User user) async {
    try {
      Response result = await api.post(_getUrl('/'), data: {
        'workout': workout.toJson(),
        'user': user.toJson(),
      });

      return {
        'workout_id': result.data['workout_id'],
        'feed_id': result.data['feed_id'],
      };
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
