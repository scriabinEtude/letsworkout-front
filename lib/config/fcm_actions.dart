import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/fcm_code.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/util/object_util.dart';

fcmAction(RemoteMessage event) {
  FcmCode? code = FcmCode.fcmCodeMap[event.data['code']];
  if (code == null) return;

  Map<String, dynamic> data = convertFcmMapToDynamic(event.data);

  switch (code) {
    case FcmCode.FCM_CODE_WORKOUT:
      AppBloc.feedCubit.addFeed(Feed.fromFcmData(data));
      break;

    case FcmCode.FCM_CODE_WORKOUT_DONE:
      AppBloc.feedCubit.removeFeed(Feed.fromFcmData(data));
      break;
    default:
  }
}
