import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void configLoading() {
  EasyLoading.instance
    ..indicatorWidget = LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.blueAccent,
      size: 60,
    )
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..animationDuration = const Duration(milliseconds: 100)
    ..boxShadow = <BoxShadow>[]
    ..backgroundColor = Colors.transparent
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.blueAccent
    ..textColor = Colors.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

snack(String message) {
  AppBloc.appCubit.appSnackBar(message);
}

unFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

loadingShow() async {
  await EasyLoading.show();
}

loadingHide() {
  EasyLoading.dismiss();
}
