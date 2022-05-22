import 'package:flutter/material.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
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
    // kakaoSDK 디버그 키 해시

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
    if (userString == null || userString == "null") {
      Navigator.pushNamed(
        context,
        Routes.loginScreen,
        // ((route) => false),
      );
    }

    //저장된 유저로 자동 로그인
    else {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('한결아 운동하자!')),
    );
  }
}
