import 'package:dio/dio.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/module/api/api.dart';

class WorkoutRepository {
  String _getUrl(String url) {
    return '/workout$url';
  }

  Future<String> postWorkout(Feed feed) async {
    Response result = await api.post(_getUrl('/'), data: {
      'feed': feed.toJson(),
    });

    return result.data['feedId'];
  }

  Future<bool> endWorkout(Feed workout) async {
    try {
      Response result = await api.put(_getUrl('/'), data: workout.toJson());
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> patchWorkout(Feed feed) async {
    try {
      Response result = await api.patch(_getUrl('/'), data: feed.toJson());
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
