import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/fcm_code.dart';
import 'package:letsworkout/model/feed_active.dart';
import 'package:letsworkout/util/object_util.dart';

fcmAction(RemoteMessage event) {
  FcmCode? code = FcmCode.fcmCodeMap[event.data['code']];
  if (code == null) return;

  Map<String, dynamic> data = convertFcmMapToDynamic(event.data);

  switch (code) {
    case FcmCode.FCM_CODE_WORKOUT:
      AppBloc.feedCubit.addFeedActive(FeedActive.fromJson(data));
      break;

    case FcmCode.FCM_CODE_WORKOUT_DONE:
      AppBloc.feedCubit.removeFeedActive(FeedActive.fromJson(data));
      break;
    default:
  }
}
