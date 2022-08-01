import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';

snack(String message) {
  AppBloc.appCubit.appSnackBar(message);
}

unFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

loadingShow() {
  AppBloc.appCubit.loadingShow();
}

loadingHide() {
  AppBloc.appCubit.loadingHide();
}
