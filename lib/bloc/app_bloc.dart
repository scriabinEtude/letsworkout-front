import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app/app_cubit.dart';
import 'package:letsworkout/bloc/login/login_cubit.dart';

class AppBloc {
  static final appCubit = AppCubit();
  static final loginCubit = LoginCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<AppCubit>(
      create: (context) => appCubit,
    ),
    BlocProvider<LoginCubit>(
      create: (context) => loginCubit,
    ),
  ];

  static void dispose() {
    appCubit.close();
    loginCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
