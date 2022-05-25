import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '${AppBloc.userCubit.user!.name ?? AppBloc.userCubit.user!.tag}아 운동하자!',
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
            //TODO calendar
            ),
      ),
    );
  }
}
