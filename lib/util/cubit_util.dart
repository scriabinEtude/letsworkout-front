import 'package:letsworkout/bloc/app_bloc.dart';

snack(String message) {
  AppBloc.appCubit.appSnackBar(message);
}
