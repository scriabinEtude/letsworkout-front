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

  Future<Map> getFollowCount({required String userId}) async {
    try {
      Response result = await api
          .get(_getUrl('/follow/count'), queryParameters: {'userId': userId});

      if (result.statusCode != 200) return {};
      return result.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getFollows({required String userId}) async {
    try {
      Response result = await api
          .get(_getUrl('/follows'), queryParameters: {'userId': userId});

      if (result.statusCode != 200) return {};
      return result.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> follow({required String myId, required String followId}) async {
    try {
      Response result = await api.post(_getUrl('/follow'), data: {
        'myId': myId,
        'followId': followId,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> unFollow(
      {required String myId, required String followId}) async {
    try {
      Response result = await api.delete(_getUrl('/follow'), data: {
        'myId': myId,
        'followId': followId,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> isFollow(
      {required String myId, required String followId}) async {
    try {
      Response result = await api.get(_getUrl('/follow'), queryParameters: {
        'myId': myId,
        'followId': followId,
      });

      return result.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
