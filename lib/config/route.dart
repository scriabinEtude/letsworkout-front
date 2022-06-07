import 'package:flutter/material.dart';
import 'package:letsworkout/screen/home_screen.dart';
import 'package:letsworkout/screen/login/agreement_screen.dart';
import 'package:letsworkout/screen/login/login_screen.dart';
import 'package:letsworkout/screen/login/register_tag_screen.dart';
import 'package:letsworkout/screen/splash_screen.dart';
import 'package:letsworkout/screen/workout/workout_start_screen.dart';

class Routes {
  static const String splashScreen = "/";
  static const String loginScreen = "/login";
  static const String agreementScreen = "/login/join/agreement";
  static const String registerTagScreen = "/login/join/tag";
  static const String homeScreen = "/home";
  static const String workoutStartScreen = "/workout/start";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: splashScreen),
            builder: (BuildContext context) {
              return const SplashScreen();
            });
      case loginScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: loginScreen),
            builder: (BuildContext context) {
              return const LoginScreen();
            });
      case agreementScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: agreementScreen),
            builder: (BuildContext context) {
              return const AgreementScreen();
            });
      case registerTagScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: registerTagScreen),
            builder: (BuildContext context) {
              return const RegisterTagScreen();
            });
      case homeScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: homeScreen),
            builder: (BuildContext context) {
              return const HomeScreen();
            });
      case workoutStartScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: workoutStartScreen),
            builder: (BuildContext context) {
              return const WorkoutStartScreen();
            });
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
