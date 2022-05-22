import 'package:letsworkout/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  static SharedPreferences? instance;

  static Future<SharedPreferences?> setPreferences() async {
    instance = await SharedPreferences.getInstance();
    return instance;
  }

  static Future<void> setUser(User user) async {
    await instance!.setString("user", jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    String? userString = instance!.getString("user");
    if (userString == null) {
      return null;
    }
    return User.fromJson(jsonDecode(userString));
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
