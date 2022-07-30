import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/fcm_code.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/like.dart';

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
      AppBloc.feedCubit.addCommentFromFcm(Comment.fromJson(data));
      break;

    case FcmCode.FCM_CODE_FEED_COMMENT_DELETE:
      AppBloc.feedCubit.removeCommentFromFcm(Comment.fromJson(data));
      break;

    case FcmCode.FCM_CODE_FEED_LIKE:
      AppBloc.feedCubit.addLikeFromFcm(Like.fromJson(data));
      break;

    case FcmCode.FCM_CODE_FEED_LIKE_DELETE:
      AppBloc.feedCubit.removeLikeFromFcm(Like.fromJson(data));
      break;
    default:
  }
}
