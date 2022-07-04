import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/module/api/api.dart';

class UserRepository {
  String _getUrl(String url) {
    return '/user$url';
  }

  Future<User?> getUserId(int id) async {
    try {
      Response result = await api.get(_getUrl('/id'), queryParameters: {
        'id': id,
      });

      if (result.data == "") return null;
      return User.fromJson(result.data);
    } catch (e) {
      print(e);
      return null;
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
      return user.copyWith(id: result.data['id']);
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

  Future<bool> updateProfileImage(int userId, String url) async {
    try {
      Response result = await api.post(_getUrl('/profile/image'), data: {
        'id': userId,
        'url': url,
      });
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteProfileImage(int userId) async {
    try {
      Response result = await api.delete(_getUrl('/profile/image'), data: {
        'id': userId,
      });
      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
