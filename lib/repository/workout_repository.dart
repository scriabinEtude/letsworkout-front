import 'package:dio/dio.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';

class WorkoutRepository {
  String _getUrl(String url) {
    return '/workout$url';
  }

  Future<bool> userActivate(int id) async {
    try {
      Response result = await api.post(_getUrl('/user/$id'));
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> userDeactivate(int id) async {
    try {
      Response result = await api.delete(_getUrl('/user/$id'));
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int?> postWorkout(Workout workout) async {
    try {
      Response result = await api.post(_getUrl('/'), data: workout.toJson());

      if (result.statusCode != 200) return null;
      return result.data['id'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> endWorkout(Workout workout) async {
    try {
      Response result = await api.put(_getUrl('/'), data: workout.toJson());
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
