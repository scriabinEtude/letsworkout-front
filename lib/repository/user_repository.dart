import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/module/api/api.dart';

class UserRepository {
  String _getUrl(String url) {
    return '/user$url';
  }

  Future<User?> login(User user) async {
    try {
      Response result = await api.get(
        _getUrl('/login'),
        queryParameters: user.toJson(),
      );

      if (result.data == "") return null;
      return User.fromJson(result.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> getUserId(String id) async {
    try {
      Response result = await api.get(_getUrl('/id'), queryParameters: {
        '_id': id,
      });

      if (result.data == "") return null;
      return User.fromJson(result.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<User>> getUsersById(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      Response result = await api.get(_getUrl('/ids'), queryParameters: {
        'ids': ids,
      });

      if (result.data == "") return [];
      return User.fromJsonList(result.data);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<User?> getUserByEmailProvider(String email, String provider) async {
    try {
      Response result = await api.get(_getUrl('/email'), queryParameters: {
        'email': email,
        'provider': provider,
      });
      if ((result.data as List).isEmpty) return null;
      return User.fromJson(result.data.first);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> registUser(User user) async {
    try {
      Response result = await api.post(_getUrl('/'), data: user.toJson());
      return user.copyWith(userId: result.data['id']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool?> isExistTag(String tag) async {
    try {
      Response result =
          await api.get(_getUrl('/tag'), queryParameters: {'tag': tag});
      return result.data;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      Response result = await api.patch(_getUrl('/'), data: user.toJson());
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfileImage(String userId, String url) async {
    try {
      Response result = await api.post(_getUrl('/profile/image'), data: {
        '_id': userId,
        'url': url,
      });
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteProfileImage(String userId) async {
    try {
      Response result = await api.delete(_getUrl('/profile/image'), data: {
        '_id': userId,
      });
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
