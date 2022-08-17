import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:letsworkout/bloc/app/app_cubit.dart';
import 'package:letsworkout/bloc/app/app_state.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/application.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/app_state_type.dart';
import 'package:letsworkout/screen/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:developer' as developer;

import 'package:letsworkout/util/widget_util.dart';

class AppBlocObserver extends BlocObserver {
  static const String TAG = "LISTAR";

  log([String tag = TAG, dynamic msg]) {
    // if (Application.appMode != AppMode.prod) {
    developer.log('$msg', name: tag);
    // }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('BLOC ONCHANGE', change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('BLOC TRANSITION', transition);
    super.onTransition(bloc, transition);
  }
}

void main() {
  // KAKAO
  KakaoSdk.init(nativeAppKey: Application.kakaoNativeAppKey);

  // package_info_plus
  WidgetsFlutterBinding.ensureInitialized();

  // easy loading
  configLoading();

  initializeDateFormatting().then((_) => BlocOverrides.runZoned(
        () => runApp(const MyApp()),
        blocObserver: AppBlocObserver(),
      ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Routes route = Routes();

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: ScreenUtilInit(
        designSize: const Size(428, 926), //pro max
        minTextAdapt: true,
        builder: (context, _) => MaterialApp(
          title: '한결아 운동하자!',
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          scrollBehavior:
              MyCustomScrollBehavior(), // how to remove scroll glow? // https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow?rq=1&answertab=trending#tab-top
          onGenerateRoute: route.generateRoute,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          home: Scaffold(
            body: BlocListener<AppCubit, AppState>(
              bloc: AppBloc.appCubit,
              listener: (context, state) {
                switch (state.type) {
                  case AppStateType.init:
                    break;
                  case AppStateType.snackBar:
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message!)));
                    break;
                  case AppStateType.successUpSnacbar:
                    throw UnsupportedError('아직 구현되지 않음.');
                }
              },
              child: const SplashScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

/// how to remove scroll glow?
///
/// 스크롤시 가장자리에 닿으면 생기는 파란 원형 제거
///
/// https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow?rq=1&answertab=trending#tab-top
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
