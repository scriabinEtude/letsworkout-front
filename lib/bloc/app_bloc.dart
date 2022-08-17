import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app/app_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/food_write/food_write_cubit.dart';
import 'package:letsworkout/bloc/login/login_cubit.dart';
import 'package:letsworkout/bloc/search/search_cubit.dart';
import 'package:letsworkout/bloc/user/user_cubit.dart';
import 'package:letsworkout/bloc/workout/workout_cubit.dart';

class AppBloc {
  static final appCubit = AppCubit();
  static final loginCubit = LoginCubit();
  static final userCubit = UserCubit();
  static final searchCubit = SearchCubit();
  static final feedCubit = FeedCubit();
  static final workoutCubit = WorkoutCubit();
  static final foodWriteCubit = FoodWriteCubit();

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
    BlocProvider<SearchCubit>(
      create: (context) => searchCubit,
    ),
    BlocProvider<FeedCubit>(
      create: (context) => feedCubit,
    ),
    BlocProvider<WorkoutCubit>(
      create: (context) => workoutCubit,
    ),
    BlocProvider<FoodWriteCubit>(
      create: (context) => foodWriteCubit,
    ),
  ];

  static void dispose() {
    appCubit.close();
    loginCubit.close();
    userCubit.close();
    searchCubit.close();
    feedCubit.close();
    workoutCubit.close();
    foodWriteCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
