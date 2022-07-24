// ignore_for_file: constant_identifier_names

enum FcmCode {
  // workout 1000
  FCM_CODE_WORKOUT(1000, "1000"),
  FCM_CODE_WORKOUT_DONE(1001, "1001"),
  FCM_CODE_WORKOUT_DELETE(1002, "1002"),

  // feed comment 1100
  FCM_CODE_FEED_COMMENT(1100, "1100"),
  FCM_CODE_FEED_COMMENT_DELETE(1101, "1101"),

// feed like 1200
  FCM_CODE_FEED_LIKE(1200, "1200"),
  FCM_CODE_FEED_LIKE_DELETE(1201, "1201");

  final int code;
  final String codeString;

  const FcmCode(this.code, this.codeString);

  static final Map<dynamic, FcmCode> fcmCodeMap = {
    ...{for (FcmCode code in FcmCode.values) code.code: code},
    ...{for (FcmCode code in FcmCode.values) code.codeString: code},
  };
}
