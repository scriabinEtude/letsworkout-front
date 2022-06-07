import 'package:dio/dio.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/module/api/api.dart';

class UserRepository {
  Future<User?> getUserId(int id) async {
    try {
      Response result = await api.get('/user/id', queryParameters: {
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
      Response result = await api.get('/user/email', queryParameters: {
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
      Response result = await api.post('/user', data: user.toJson());
      return user.copyWith(id: result.data['id']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool?> isExistTag(String tag) async {
    try {
      Response result =
          await api.get('/user/tag', queryParameters: {'tag': tag});
      return result.data;
    } catch (e) {
      return null;
    }
  }
}
