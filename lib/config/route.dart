import 'package:flutter/material.dart';
import 'package:letsworkout/screen/login/login_screen.dart';

class Routes {
  static const String loginScreen = "/login";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: loginScreen),
            builder: (BuildContext context) {
              return const LoginScreen();
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
