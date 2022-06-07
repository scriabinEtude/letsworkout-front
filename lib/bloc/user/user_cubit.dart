import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/user.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  Future<User?> loadInitialData() async {
    User? user = await Preferences.userGet();
    emit(user);
    return user;
  }

  Future<void> setUser(User user) async {
    await Preferences.userSet(user);
    emit(user);
  }

  //** 로그인된 유저를 지우고 스플래시로 이동 */
  Future<void> logout(BuildContext context) async {
    await Preferences.userInit();
    emit(null);
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.splashScreen, (_) => false);
  }

  User? get user => state;
}
