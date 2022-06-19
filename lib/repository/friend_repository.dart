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
}
