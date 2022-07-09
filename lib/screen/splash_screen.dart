import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/firebase_options.dart';
import 'package:letsworkout/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
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
        .then<SharedPreferences?>(permissionInit) // permissions
        .then<SharedPreferences?>(firebaseInit) // firebase
        .then<SharedPreferences?>(checkLastLoginHistory); // login
  }

  Future<SharedPreferences?> permissionInit(SharedPreferences? prefs) async {
    if (await Permission.notification.request().isGranted) {}
    return prefs;
  }

  Future<SharedPreferences?> firebaseInit(SharedPreferences? prefs) async {
    // FIRE BASE 설정
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      // 안드로이드
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'letsworkout', // id
        'letsworkout', // title
        importance: Importance.high,
      );

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // IOS
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return prefs;
  }

  Future<SharedPreferences?> checkLastLoginHistory(
      SharedPreferences? prefs) async {
    String? userString = prefs!.getString("user");

    //저장된 유저가 없으므로 로그인으로 이동
    if (userString == null || userString == "null" || userString.isEmpty) {
      Navigator.pushNamed(
        context,
        Routes.loginScreen,
      );
    }

    //저장된 유저로 자동 로그인
    else {
      User? user = await AppBloc.userCubit.loadInitialData();
      if (await AppBloc.loginCubit.autoLogin(user!)) {
        Navigator.pushNamed(context, Routes.homeScreen);
      }
      // 자동로그인 실패하면 로그인 화면으로
      else {
        Navigator.pushNamed(
          context,
          Routes.loginScreen,
        );
      }
    }

    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('한결아 운동하자!')),
    );
  }
}
