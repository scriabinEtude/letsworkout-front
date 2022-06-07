import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app/app_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/login/login_cubit.dart';
import 'package:letsworkout/bloc/user/user_cubit.dart';

class AppBloc {
  static final appCubit = AppCubit();
  static final loginCubit = LoginCubit();
  static final userCubit = UserCubit();
  static final feedCubit = FeedCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<AppCubit>(
      create: (context) => appCubit,
    ),
    BlocProvider<LoginCubit>(
      create: (context) => loginCubit,
    ),
    BlocProvider<UserCubit>(
      create: (context) => userCubit,
    ),
    BlocProvider<FeedCubit>(
      create: (context) => feedCubit,
    ),
  ];

  static void dispose() {
    appCubit.close();
    loginCubit.close();
    userCubit.close();
    feedCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
