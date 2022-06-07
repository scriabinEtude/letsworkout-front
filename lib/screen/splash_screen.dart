import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // TODO 버전 체크
    // TODO 권한체크

    // 앱 데이터 불러오기
    Preferences.setPreferences()
        .then<SharedPreferences?>(checkLastLoginHistory);
  }

  Future<SharedPreferences?> checkLastLoginHistory(
      SharedPreferences? prefs) async {
    String? userString = prefs!.getString("user");

    //저장된 유저가 없으므로 로그인으로 이동
    if (userString == null || userString == "null" || userString.isEmpty) {
      Navigator.pushReplacementNamed(
        context,
        Routes.loginScreen,
      );
    }

    //저장된 유저로 자동 로그인
    else {
      User? user = await AppBloc.userCubit.loadInitialData();
      if (await AppBloc.loginCubit.autoLogin(user!)) {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('한결아 운동하자!')),
    );
  }
}
