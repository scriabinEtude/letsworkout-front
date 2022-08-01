import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/feed/feed_cubit.dart';
import 'package:letsworkout/bloc/feed/feed_state.dart';
import 'package:letsworkout/enum/workout_type.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/util/widget_util.dart';
import 'package:letsworkout/widget/comment_input_field.dart';
import 'package:letsworkout/widget/comment_list.dart';
import 'package:letsworkout/widget/photo_cards.dart';
import 'package:letsworkout/widget/scaffold.dart';

class WorkoutStartScreen extends StatefulWidget {
  const WorkoutStartScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutStartScreen> createState() => _WorkoutStartScreenState();
}

class _WorkoutStartScreenState extends State<WorkoutStartScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scroller = ScrollController();
  Workout? workout;
  Timer? timer;
  FileActions images = FileActions([]);
  // var keyboardVisibilityController = KeyboardVisibilityController();
  // late final StreamSubscription<bool> keyboardSubscription;
  bool _textHasFocus = false;

  @override
  void initState() {
    // 운동중이었다면 상태 가져와서 세팅
    // 운동중 상태는 앱내 저장함
    initData();

    super.initState();

    // Subscribe
    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (visible) {
    //     Timer(const Duration(milliseconds: 200), () {
    //       _scroller.animateTo(
    //         _scroller.position.pixels +
    //             MediaQuery.of(context).viewInsets.bottom +
    //             50,
    //         duration: const Duration(milliseconds: 100),
    //         curve: Curves.easeIn,
    //       );
    //     });
    //   }
    // });

    _focusNode.addListener(() {
      setState(() {
        _textHasFocus = _focusNode.hasFocus;
      });
    });

    // 1초마다 갱신하는 타이머 동작
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  Future initData() async {
    setData(await AppBloc.workoutCubit.loadData());
    if (workout != null) {
      AppBloc.feedCubit.commentGet(feedId: workout!.feedId);
    }
  }

  void setData(Workout? newWorkout) {
    workout = newWorkout;
    _textController.text = workout?.description ?? "";
    images = workout?.images ?? FileActions([]);
    setState(() {});
  }

  @override
  void dispose() {
    // 운동상태 저장
    if (workout != null) {
      AppBloc.workoutCubit.workoutSaveLocal(
        description: _textController.text,
        fileActions: images,
      );
    }

    // keyboardSubscription.cancel();
    _textController.dispose();
    _commentController.dispose();
    _scroller.dispose();
    _focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('운동하기'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: appBarSingleAction(
                onTap: () async {
                  setData(await AppBloc.workoutCubit.workoutSave(
                    description: _textController.text,
                    fileActions: images,
                  ));
                },
                child: const Text('저장')),
          ),
          bottomNavigationBar: CommentInputField(
            display: workout != null && !_textHasFocus,
            controller: _commentController,
            onChanged: (text) => setState(() {}),
            onPressed: () async {
              await AppBloc.feedCubit.workoutingCommentInsert(
                feedId: workout!.feedId!,
                depth: 0,
                parentId: null,
                comment: _commentController.text,
              );
              _commentController.text = "";
              setState(() {});
            },
          ),
          body: SingleChildScrollView(
            controller: _scroller,
            child: Column(
              children: [
                const SizedBox(height: 20),
                PhotoCards(
                  images: images,
                  onActions: () => setState(() {}),
                  isViewMode: false,
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  children: [
                    workoutStartEndButtonWidget(),
                    workoutTimerWidget(),
                  ],
                ),
                const SizedBox(height: 20),
                workoutTextField(),
                const SizedBox(height: 100),
                const Text('현재 진행중인 운동은 최신 댓글이 가장 상위에 노출됩니다.'),
                BlocBuilder<FeedCubit, FeedState>(
                  bloc: AppBloc.feedCubit,
                  builder: (context, state) {
                    if (state.comments.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return CommentColumn(
                      feedCubit: AppBloc.feedCubit,
                      myId: AppBloc.userCubit.user?.userId,
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  String workoutTimer() {
    if (workout == null || workout!.workoutType != WorkoutType.working.index) {
      return "00:00";
    }

    String time = "";
    DateTime endTime = workout!.endTime != null
        ? DateTime.parse(workout!.endTime!)
        : DateTime.now();
    Duration difference = endTime.difference(DateTime.parse(workout!.time!));
    int hour = difference.inSeconds ~/ (60 * 60);
    int min = difference.inSeconds ~/ 60 % 60;
    int sec = difference.inSeconds % 60;

    time += hour > 0 ? "${hour.toString().padLeft(2, "0")}:" : "";
    time += "${min.toString().padLeft(2, "0")}:";
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
    if (AppBloc.workoutCubit.isNotWorkoutStart) {
      title = "운동 시작!";
      buttonColor = Colors.lightBlue[400]!.withOpacity(0.5);
      onTap = () async {
        setData(await AppBloc.workoutCubit.workoutStart());
      };
    }
    // 운동 시작 했을 때
    else {
      title = "운동 끝내기";
      buttonColor = Colors.amber[100]!;
      onTap = () async {
        // 운동정보 저장
        setData(await AppBloc.workoutCubit.workoutEnd(
          description: _textController.text,
          fileActions: images,
        ));
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

  Widget workoutTextField() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0xfff7f7f7)),
        child: TextField(
          focusNode: _focusNode,
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
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: '운동 내용을 입력해주세요.',
              hintStyle: TextStyle(color: Color(0xffb2b2b2))),
        ));
  }
}
