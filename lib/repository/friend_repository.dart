import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/module/api/api.dart';

class FriendRepository {
  String _getUrl(String url) {
    return '/friend$url';
  }

  Future<List<User>> searchFriends({
    required String word,
  }) async {
    if (word.isEmpty) return [];

    try {
      Response result =
          await api.get(_getUrl('/search'), queryParameters: {'word': word});
      return result.statusCode == 200 ? User.fromJsonList(result.data) : [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map> getFollowCount({required int userId}) async {
    try {
      Response result = await api
          .get(_getUrl('/follow/count'), queryParameters: {'user_id': userId});

      if (result.statusCode != 200) return {};
      return result.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getFollows({required int userId}) async {
    try {
      Response result = await api
          .get(_getUrl('/follows'), queryParameters: {'user_id': userId});

      if (result.statusCode != 200) return {};
      return result.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> follow({required int myId, required int followId}) async {
    try {
      Response result = await api.post(_getUrl('/follow'), data: {
        'my_id': myId,
        'follow_id': followId,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> unFollow({required int myId, required int followId}) async {
    try {
      Response result = await api.delete(_getUrl('/follow'), data: {
        'my_id': myId,
        'follow_id': followId,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> isFollow({required int myId, required int followId}) async {
    try {
      Response result = await api.get(_getUrl('/follow'), queryParameters: {
        'my_id': myId,
        'follow_id': followId,
      });

      return result.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
