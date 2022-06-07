import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/workout.dart';

class WorkoutStartScreen extends StatefulWidget {
  const WorkoutStartScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutStartScreen> createState() => _WorkoutStartScreenState();
}

class _WorkoutStartScreenState extends State<WorkoutStartScreen> {
  final TextEditingController _textController = TextEditingController();
  Workout? workout;
  Timer? timer;

  @override
  void initState() {
    // 운동중이었다면 상태 가져와서 세팅
    // 운동중 상태는 앱내 저장함
    workout = Preferences.workoutGet();
    _textController.text = workout?.content ?? "";
    super.initState();

    // 운동이 끝난 상태면 초기화
    if (workout != null && workout!.workoutType == WorkoutType.end.index) {
      Preferences.workoutRemove().then((_) {
        workout = null;
        setState(() {});
      });
    }

    // 1초마다 갱신하는 타이머 동작
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // 운동상태 저장
    if (workout != null) {
      Preferences.workoutSet(
        workout!.copyWith(content: _textController.text),
      );
    }
    _textController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('운동하기'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                workoutStartEndButtonWidget(),
                workoutTimerWidget(),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Color(0xfff7f7f7)),
                    child: TextField(
                      // 시작전과 운동중일 때 작성 가능
                      enabled: workout == null ||
                          workout!.workoutType == WorkoutType.working.index,
                      maxLength: 1000,
                      controller: _textController,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: '운동 내용을 입력해주세요.',
                          hintStyle: TextStyle(color: Color(0xffb2b2b2))),
                    )),
              ],
            ),
          )),
    );
  }

  String workoutTimer() {
    if (workout == null) {
      return "00:00";
    }

    String time = "";
    DateTime endTime = workout!.endTime != null
        ? DateTime.parse(workout!.endTime!)
        : DateTime.now();
    Duration difference =
        endTime.difference(DateTime.parse(workout!.startTime));
    int hour = difference.inSeconds ~/ (60 * 60);
    int min = difference.inSeconds ~/ 60 % 60;
    int sec = difference.inSeconds % 60;

    time += hour > 0 ? hour.toString().padLeft(2, "0") : "";
    time += min.toString().padLeft(2, "0") + ":";
    time += sec.toString().padLeft(2, "0");
    return time;
  }

  Widget workoutTimerWidget() {
    return Container(
      width: 150,
      height: 50,
      color: Colors.green.withOpacity(0.2),
      child: Center(
        child: Text(workoutTimer()),
      ),
    );
  }

  Widget workoutStartEndButtonWidget() {
    String title;
    Color buttonColor;
    void Function() onTap;

    // 운동 시작 안 했을 때
    if (workout == null) {
      title = "운동 시작!";
      buttonColor = Colors.lightBlue[400]!.withOpacity(0.5);
      onTap = () async {
        workout = await Preferences.workoutStart();
        setState(() {});
      };
    }
    // 운동 시작 했을 때
    else if (workout!.workoutType == WorkoutType.working.index) {
      title = "운동 끝내기";
      buttonColor = Colors.amber[100]!;
      onTap = () async {
        // 운동정보 저장
        await Preferences.workoutSet(
          workout!.copyWith(content: _textController.text),
        );
        workout = await Preferences.workoutEnd();
        _textController.text = "";
        setState(() {});
      };
    }
    // 운동을 종료했을 때
    else {
      title = "운동 종료";
      buttonColor = Colors.grey[400]!;
      onTap = () async {
        final resultAlert = await showOkCancelAlertDialog(
          context: context,
          message: '운동을 다시 시작하시겠습니까?',
          okLabel: "확인",
          cancelLabel: "취소",
        );
        if (resultAlert == OkCancelResult.ok) {
          await Preferences.workoutRemove();
          workout = Preferences.workoutGet();
          setState(() {});
        }
      };
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
