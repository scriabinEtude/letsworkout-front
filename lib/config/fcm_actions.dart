import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/fcm_code.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';

fcmAction(RemoteMessage event) {
  FcmCode? code = FcmCode.fcmCodeMap[event.data['code']];
  if (code == null) return;

  Map<String, dynamic> data = jsonDecode(event.data['payload']);

  switch (code) {
    case FcmCode.FCM_CODE_WORKOUT:
      AppBloc.feedCubit.addFeed(Feed.fromJson(data));
      break;

    case FcmCode.FCM_CODE_WORKOUT_DONE:
      AppBloc.feedCubit.removeFeed(Feed.fromJson(data));
      break;

    case FcmCode.FCM_CODE_FEED_COMMENT:
      AppBloc.workoutCubit.addComment(Comment.fromJson(data));
      break;

    case FcmCode.FCM_CODE_FEED_COMMENT_DELETE:
      AppBloc.workoutCubit.removeComment(Comment.fromJson(data));
      break;

    // case FcmCode.FCM_CODE_FEED_LIKE:
    //   AppBloc.feedCubit.removeFeed(Feed.fromJson(data));
    //   break;

    // case FcmCode.FCM_CODE_FEED_LIKE_DELETE:
    //   AppBloc.feedCubit.removeFeed(Feed.fromJson(data));
    //   break;
    default:
  }
}
