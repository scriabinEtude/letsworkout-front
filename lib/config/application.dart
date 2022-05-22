import 'package:letsworkout/enum/app_mode.dart';

class Application {
  static const AppMode appMode = AppMode.local;
  static const String kakaoNativeAppKey = "03c10feba0f296bdf1757e6d4a6def2a";

  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }
  Application._internal();
}
