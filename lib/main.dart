import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:letsworkout/bloc/app/app_cubit.dart';
import 'package:letsworkout/bloc/app/app_state.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/config/application.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/screen/splash_screen.dart';
import 'dart:developer' as developer;

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
  KakaoSdk.init(nativeAppKey: Application.kakaoNativeAppKey);

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
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
        builder: (_) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          onGenerateRoute: route.generateRoute,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: BlocListener<AppCubit, AppState>(
              bloc: AppBloc.appCubit,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              },
              child: const SplashScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
